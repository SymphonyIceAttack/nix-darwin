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

  dotenv = {
    disableHint = true;
    enable = true;
    filename = ".env.crush";
  };

  git-hooks = {
    enable = false;
    configPath = ".git/hooks/pre-commit";
  };

}
