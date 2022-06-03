{ pkgs, ... }:
let
  PWD = builtins.toString ./.;
in
{
  enable = true;
  vimAlias = true;
  
  extraConfig = ''
    luafile ${PWD}/settings.lua
  '';
  
  plugins = with pkgs.vimPlugins; [
  ];
}
