{
  config,
  lib,
  ...
}: {
  nix = {
    settings.substituters = ["https://nix-cache.rubek.cloud/main"];
    settings.trusted-public-keys = ["main:Zm2mvcYcYQSKj7ex2IKmdT4/jqPo8OnXnUBe/WdI2aA="];
  };
}
