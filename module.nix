{ pkgs, lib, config, ... }:

with lib;

let
  installer = pkgs.nixos [
    ./installer.nix

    {
      _module.args = {
        target = config;
      };
    }
  ];

in {

  config = {
    system.build.netinstaller = installer;

    system.build.netinstaller-pixiecore = system: let
      hostPkgs = if pkgs.system == system
        then pkgs
        else (import pkgs.path).legacyPackages.${system};

    in pkgs.writers.writeBash "netinstall-${config.networking.hostName}" ''
      exec ${hostPkgs.pixiecore}/bin/pixiecore boot \
        "${installer.config.system.build.kernel}/bzImage" \
        "${installer.config.system.build.netbootRamdisk}/initrd" \
        --cmdline "init=${installer.config.system.build.toplevel}/init loglevel=4" \
        --debug \
        --dhcp-no-bind \
        "$@"
    '';

    assertions = [
      { assertion = hasAttr "diskoScript" config.system.build;
        message = "Using netinstaller.nix requires disko";
      }
    ];
  };
}
