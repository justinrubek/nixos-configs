{
  inputs,
  self,
  ...
}: let
  sshModule = {
    justinrubek.administration = {
      enable = true;
    };
  };
in {
  justinrubek.nixosConfigurations = {
    # physical machines
    manusya.system = "x86_64-linux";
    eunomia.system = "x86_64-linux";
    surface.system = "x86_64-linux";
    rpi5.system = "aarch64-linux";

    # cloud servers
    bunky = {
      system = "x86_64-linux";
      modules = [sshModule];
    };
    pyxis = {
      system = "x86_64-linux";
      modules = [sshModule];
    };
    ceylon = {
      system = "x86_64-linux";
      modules = [sshModule];
    };
    huginn = {
      system = "x86_64-linux";
      modules = [sshModule];
    };
    alex = {
      system = "x86_64-linux";
      modules = [sshModule];
    };

    # other
    hetzner-base = {
      system = "x86_64-linux";
      modules = [sshModule];
    };
  };
}
