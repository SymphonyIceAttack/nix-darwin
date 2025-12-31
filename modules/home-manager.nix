{ lib, ... }:
let
  user = "symphoneice";
  homeDirectory = "/Users/${user}";
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;
  users.users.${user} = {
    name = user;
    home = homeDirectory;
  };
  home-manager.users.${user} =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";
      home.homeDirectory = homeDirectory;
      home.username = user;
      home.file = {
        ".warp".source = /etc/nix-darwin/config/.warp;
        ".zshrc".source = /etc/nix-darwin/config/.zshrc;
        ".gitconfig".source = /etc/nix-darwin/config/.gitconfig;
        ".config/helix".source = /etc/nix-darwin/config/helix;
        ".config/yazi".source = /etc/nix-darwin/config/yazi;
        ".config/jj".source = /etc/nix-darwin/config/jj;
      };
    };
}
