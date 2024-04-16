_inputs:
{ pkgs, ... }:
{
  config = {
    activeProfiles = [ "development" ];
    home.stateVersion = "21.11";
  };
}
