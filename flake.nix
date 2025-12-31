{
  description = "SymphoneIce nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      mac-app-util,
      nix-homebrew,
      home-manager,
    }:
    let
      nixpkgs.config.allowUnfree = true;

      configuration =
        { pkgs, config, ... }:
        {
          imports = [
            (self + "/modules/packages.nix")
            (self + "/modules/homebrew.nix")
            (self + "/modules/fonts.nix")
            (self + "/modules/system-defaults.nix")
            (self + "/modules/home-manager.nix")
          ];

          system.primaryUser = "symphoneice";

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "symphoneice"
          ];
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };

    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#SymphoneIcedeMacBook-Pro
      darwinConfigurations."SymphoneIcedeMacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          # This is a Nix module for Macintosh computers ("darwin")
          # which fixes a few common problems encountered by users of
          # Nix on Macs:
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "symphoneIce";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
              # Optional: Declarative tap management
              taps = {
              };
            };
          }
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
