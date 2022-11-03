{self, ...} @ inputs: {
  "justin@manusya" = self.lib.mkHome "justin" "manusya" "x86_64-linux" inputs.nixpkgs;
  "justin@eunomia" = self.lib.mkHome "justin" "eunomia" "x86_64-linux" inputs.nixpkgs;
}
