{self, ...} @ inputs: {
  manusya = self.lib.mkSystem "manusya" inputs.unixpkgs;
  eunomia = self.lib.mkSystem "eunomia" inputs.unixpkgs;
}
