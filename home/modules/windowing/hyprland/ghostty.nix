{pkgs, ...}: {
  home.packages = [
    pkgs.ghostty
  ];
  xdg.configFile."ghostty/config".text = ''
    mouse-hide-while-typing = true
    theme = "tokyonight"
    window-decoration = false
  '';
}
