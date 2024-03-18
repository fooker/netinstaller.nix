# `netinstaller.nix`

A NixOS module to provies a one-shot netinstaller image for automated installation.

This builds a netboot image which installs the target system unattended.
Therefore the system must be build using [disko](https://github.com/nix-community/disko).

To use the module, either import the `module.nix` in you configuration or use `nixosModules.netinstaller` provided by the flake.

> [!CAUTION]
> This will erase the disk of any system, that boots using the installer image! Make sure to use only in environments that you have full control of.

The module adds additional build outputs to your system:

#### `system.build.netinstaller`
The PXE netboot image containing the automated installer.
This is an attribute-set similar to `system.build.toplevel`.

#### `system.build.netinstaller-pixiecore`
A function which accepts the host system architecture and evaluates to a script starting [pixiecore](https://github.com/danderson/netboot/tree/main/pixiecore) to serve the PXE netboot image provided by `system.build.netinstaller`.
