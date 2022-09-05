{
  config,
  lib,
  ...
}: {
  nix = {
    settings.substituters = ["https://justinrubek.cachix.org"];
    settings.trusted-public-keys = ["justinrubek.cachix.org-1:rncFMMXairb7cvGWQVEKxyonhedpZw6smsFW2hARz0U="];
  };
}
