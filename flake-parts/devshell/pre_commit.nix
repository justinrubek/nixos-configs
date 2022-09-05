{pre-commit-hooks, ...} @ inputs: system:
  pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
    };
  }
