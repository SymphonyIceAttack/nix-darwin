{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  git-hooks = {
    enable = false;
    configPath = ".git/hooks/pre-commit";
  };

}
