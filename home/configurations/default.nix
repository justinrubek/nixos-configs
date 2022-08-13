{self, ...} @ inputs: {
  "justin@manusya" = self.lib.mkHome "justin" "manusya" "x86_64-linux" inputs.nixpkgs;
}
