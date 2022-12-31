input @ {
  self,
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

  # TODO: Rework structure of the flake's nixosConfigurations to not need this everywhere
  mkLegacyConfig = {
    name,
    modules ? [],
    system,
    ...
  }: {
    inherit system;

    modules = let
      configDir = "${self}/nixos/configurations/${name}";
      entryPoint = import configDir (inputs // {inherit self;});
      bootloader = "${configDir}/bootloader.nix";
      hardware = "${configDir}/hardware.nix";
    in
      [
        # import the expected modules
        entryPoint
        bootloader
        hardware
      ]
      ++ modules;
  };
in {
  justinrubek.nixosConfigurations = {
    # physical machines
    manusya = mkLegacyConfig {
      system = "x86_64-linux";
      name = "manusya";
    };

    eunomia = mkLegacyConfig {
      system = "x86_64-linux";
      name = "eunomia";
    };

    # cloud servers
    bunky = mkLegacyConfig {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      name = "bunky";
    };
    pyxis = mkLegacyConfig {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      name = "pyxis";
    };
    ceylon = mkLegacyConfig {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      name = "ceylon";
    };
    huginn = mkLegacyConfig {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      name = "huginn";
    };
    alex = mkLegacyConfig {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      name = "alex";
    };

    # other
    hetzner-base = mkLegacyConfig {
      system = "x86_64-linux";
      modules = hetznerModules ++ sshModule;
      name = "hetzner-base";
    };
  };
}
