{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    scripts.url = "github:dgengtek/scripts";

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, haumea, scripts }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs-stable { config = { }; overlays = [ ]; inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.stow
          pkgs.python3
          scripts.lib.build
        ];
      };

      homeModules.dgeng.nvim = import ./home-modules/nvim.nix;

      homeConfigurations."dgeng@wsdg" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          self.homeModules.dgeng.nvim
          {
            dotfiles = {
              neovim.enable = true;
              neovim.enableLSP = true;
            };
            home = {
              username = "dgeng";
              homeDirectory = "/home/intranet.dgeng.eu/dgeng";
              stateVersion = "25.11";
            };
            programs.home-manager.enable = true;
          }
        ];
      };

    };
}
