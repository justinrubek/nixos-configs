{pkgs, ...}: let
  copilot = pkgs.vimUtils.buildVimPlugin {
    name = "copilot-chat-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "0668308";
      sha256 = "sha256-vBQimv2gB+yQs8e9oH45R9X0QRgBETgR0nnAmeFvDG4=";
    };
  };
in {
  plugins.copilot-vim = {
    enable = true;
    package = copilot;
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "copilot-chat-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "copilotc-nvim";
        repo = "copilotchat.nvim";
        rev = "f694cca";
        sha256 = "sha256-jZb+dqGaZEs1h2CbvsxbINfHauwHka9t+jmSJQ/mMFM=";
      };
    })
  ];

  extraConfigLua = ''
    require("CopilotChat").setup {
      debug = true,
    }
  '';
}
