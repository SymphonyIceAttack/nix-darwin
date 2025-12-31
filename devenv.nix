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

}
