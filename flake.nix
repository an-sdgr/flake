{
  description = "an-sdgr's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in {
      overlays.default = final: prev: {
        neovimConfigured = final.callPackage ./packages/neovimConfigured { };
        fix-vscode = final.callPackage ./packages/fix-vscode { };
      };

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
        in {
          inherit (pkgs) neovimConfigured fix-vscode;

          # Excluded from overlay deliberately to avoid people accidently importing it.
          unsafe-bootstrap = pkgs.callPackage ./packages/unsafe-bootstrap { };
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          default = pkgs.mkShell {
            inputsFrom = with pkgs; [ ];
            buildInputs = with pkgs; [ nixpkgs-fmt ];
          };
        });

      homeConfigurations = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          nason = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./users/nason/home.nix ];
          };
        });

      nixosConfigurations = let
        # Shared config between both the liveimage and real system
        aarch64Base = {
          system = "aarch64-linux";
          modules = with self.nixosModules; [
            { config = { nix.registry.nixpkgs.flake = nixpkgs; }; }
            home-manager.nixosModules.home-manager
            traits.overlay
            traits.base
            services.openssh
          ];
        };
        x86_64Base = {
          system = "x86_64-linux";
          modules = with self.nixosModules; [
            { config = { nix.registry.nixpkgs.flake = nixpkgs; }; }
            home-manager.nixosModules.home-manager
            traits.overlay
            traits.base
            services.openssh
          ];
        };
      in with self.nixosModules; {
        x86_64IsoImage = nixpkgs.lib.nixosSystem {
          inherit (x86_64Base) system;
          modules = x86_64Base.modules
            ++ [ platforms.iso-minimal platforms.mini traits.iso ];
        };
        aarch64IsoImage = nixpkgs.lib.nixosSystem {
          inherit (aarch64Base) system;
          modules = aarch64Base.modules ++ [
            platforms.iso
            {
              config = {
                virtualisation.vmware.guest.enable = nixpkgs.lib.mkForce false;
                services.xe-guest-utilities.enable = nixpkgs.lib.mkForce false;
              };
            }
          ];
        };
        mini = nixpkgs.lib.nixosSystem {
          inherit (x86_64Base) system;
          modules = x86_64Base.modules
            ++ [ platforms.mini traits.machine traits.k3s users.nason ];
        };
      };

      nixosModules = {
        platforms.container = ./platforms/container.nix;
        platforms.mini = ./platforms/mini.nix;
        platforms.iso-minimal =
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        platforms.iso =
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.iso = ./traits/iso.nix;
        traits.machine = ./traits/machine.nix;
        traits.k3s = ./traits/k3s.nix;
        services.openssh = ./services/openssh.nix;
        traits.workstation = ./traits/workstation.nix;
        users.nason = ./users/nason;
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          format = pkgs.runCommand "check-format" {
            buildInputs = with pkgs; [ rustfmt cargo ];
          } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out # it worked!
          '';
        });

    };
}
