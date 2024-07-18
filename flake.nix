{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    scripts.url = "github:dgengtek/scripts";
  };
  outputs = { self, nixpkgs, scripts }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { config = { }; overlays = [ ]; inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.stow
          pkgs.python3
          scripts.lib.build
        ];
      };
    };
}
