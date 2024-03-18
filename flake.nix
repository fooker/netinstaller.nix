{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self
            , nixpkgs
            , flake-utils
            , ... }:
  {
    nixosModules.default = self.nixosModules.netinstaller;
    nixosModules.netinstaller = import ./module.nix;
  };
}

