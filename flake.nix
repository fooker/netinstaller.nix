{
  inputs = {
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

