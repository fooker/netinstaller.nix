{ pkgs, lib, modulesPath, config, target, ... }:

with lib;

let
  installer = pkgs.writers.writeBash "installer" (with target.system.build; ''
    set -euo pipefail

    "${diskoScript}"

    "${nixos-install}/bin/nixos-install" \
      --root /mnt \
      --system "${toplevel}" \
      --no-channel-copy \
      --no-root-password \
      --verbose

    reboot
  '');

in {
  imports = [
    "${modulesPath}/installer/netboot/netboot-minimal.nix"
  ];

  config = {
    services.getty.autologinUser = mkForce "root";

    networking.hostName = "${target.networking.hostName}-installer";

    systemd.services."auto-install" = {
      description = "Automated NixOS installer";

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      conflicts = [ "getty@tty1.service" ];

      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ bash nix ];

      unitConfig = {
        FailureAction = "force-reboot";
      };

      serviceConfig = {
        Type = "oneshot";
        
        ExecStart = installer;

        StandardInput = "none";
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
    };

    system.stateVersion = config.system.nixos.release;
  };
}

