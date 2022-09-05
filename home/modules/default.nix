inputs: {
  "profiles" = import ./profiles inputs;
  "profiles/base" = import ./profiles/base inputs;
  "profiles/development" = import ./profiles/development inputs;

  "programs/neovim" = import ./programs/neovim inputs;
  "programs/firefox" = import ./programs/firefox inputs;
}
