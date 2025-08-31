{pkgs, ...}: {
  home.packages = [
    pkgs.ghostty
  ];
  xdg.configFile."ghostty/config".text = ''
    background-opacity = 0.65
    keybind = ctrl+enter=new_window
    mouse-hide-while-typing = true
    theme = "tokyonight"
    window-decoration = false
  '';
}
