{
  inputs,
  config,
  ...
}: let
  modulesPath = "${inputs.nixpkgs}/nixos/modules";

  hetznerModules = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  sshModule = [
    {
      justinrubek.administration = {
        enable = true;
      };
    }
  ];
in {
  justinrubek.nixosConfigurations = {
    manusya.system = "x86_64-linux";
    eunomia.system = "x86_64-linux";

    bunky = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      bootloader = config.justinrubek.nixosConfigurations.hetzner-base.bootloader;
    };
    hetzner-base = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };
  };
}
