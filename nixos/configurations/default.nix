{self, ...} @ inputs: {
  manusya = self.lib.mkSystem "manusya" inputs.unixpkgs;
}
