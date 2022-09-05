inputs: {
  "profiles" = import ./profiles inputs;
  "profiles/base" = import ./profiles/base inputs;
  "profiles/development" = import ./profiles/development inputs;
  "profiles/browsing" = import ./profiles/browsing inputs;
  "profiles/gaming" = import ./profiles/gaming inputs;

  "programs/neovim" = import ./programs/neovim inputs;
  "programs/firefox" = import ./programs/firefox inputs;

  "misc/home" = import ./misc/home inputs;
}
