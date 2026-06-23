{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    scripts.url = "git+ssh://git/dgeng/scripts";
    ops-vars.url = "git+ssh://git/ops/ops-vars";
    nixutils.url = "git+ssh://git/ops/nixutils";

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, sops-nix, ops-vars, nixutils, haumea, scripts }@inputs:
    let
      system = "x86_64-linux";
      username = "dgeng";
      pkgs = import nixpkgs-stable { config = { }; overlays = [ ]; inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.stow
          pkgs.python3
          scripts.lib.build
          pkgs.home-manager
        ];
      };

      homeModules.dgeng = {
        nvim = import ./home-modules/nvim.nix;
        config = import ./home-modules/config.nix;
      };

      homeManagerModules = {
        tmux = import ./home-manager/tmux.nix;
      };

      homeConfigurations."dgeng@wsdg" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs system;
          libdg = inputs.nixutils.lib.${system};
        };
        modules = [
          self.homeManagerModules.tmux
          self.homeModules.dgeng.nvim
          self.homeModules.dgeng.config
          sops-nix.homeManagerModules.sops
          ops-vars.homeModules.dgeng.accounts
          {
            dotfiles = {
              neovim.enable = true;
              neovim.enableLSP = true;
              email.enable = true;
            };
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "26.05";
            };
            programs.home-manager.enable = true;
          }
        ];
      };

    };
}
