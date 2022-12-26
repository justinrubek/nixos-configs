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
    # physical machines
    manusya.system = "x86_64-linux";
    eunomia.system = "x86_64-linux";

    # cloud servers
    bunky = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };
    pyxis = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };
    ceylon = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };
    huginn = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };
    alex = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };

    # other
    hetzner-base = {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
    };
  };
}
