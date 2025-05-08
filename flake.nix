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
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.mkalias
            pkgs.cargo
            pkgs.go
            pkgs.lua
            pkgs.git
            pkgs.pyright
            pkgs.nixfmt-rfc-style
            pkgs.fzf
            pkgs.ripgrep
            pkgs.lazygit
            pkgs.wget
            pkgs.gopls
            pkgs.devenv
            pkgs.direnv
            pkgs.lazyjj
          ];
          environment.shellAliases = {
          };
          fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
            pkgs.nerd-fonts.hack
          ];

          homebrew = {
            enable = true;
            brews = [
              "mas"
              "python"
              "neovim"
              "nvm"
              "jj"
              "imagemagick"
            ];
            casks = [
              {
                name = "docker";
                greedy = true;
              }
              {
                name = "input-source-pro";
                greedy = true;
              }
              {
                name = "telegram";
                greedy = true;
              }
              {
                name = "warp";
                greedy = true;
              }
              {
                name = "discord";
                greedy = true;
              }
              {
                name = "spotify";
                greedy = true;
              }
              {
                name = "wechat";
                greedy = true;
              }
              {
                name = "qq";
                greedy = true;
              }
              {
                name = "arc";
                greedy = true;
              }
              {
                name = "signal";
                greedy = true;
              }
            ];
            masApps = {

            };
            onActivation = {
              cleanup = "zap";
              autoUpdate = true;
              upgrade = true;
            };
            taps = [
              #  {
              #   name="user/repo";
              #   clone_target="githuburl";
              #   force_auto_update=true;
              #  }
            ];
          };

          system.defaults = {
            dock.autohide = true;
            dock.persistent-apps = [
              "/System/Applications/Launchpad.app"
              "/System/Applications/System Settings.app"
              "/System/Applications/Messages.app"
              "/System/Applications/Mail.app"
              "/System/Applications/App Store.app"
              "/Applications/Telegram.app"
              "/Applications/Surge.app"
              "/Applications/Steam.app"
              "/Applications/Spotify.app"
              "/Applications/Discord.app"
              "/Applications/WeChat.app"
              "/Applications/QQ.app"
              "/Applications/Warp.app"
              "/Applications/Arc.app"
            ];
            dock.mru-spaces = false;
            loginwindow.GuestEnabled = false;
            NSGlobalDomain.AppleICUForce24HourTime = true;
            NSGlobalDomain.AppleInterfaceStyle = "Dark";
            NSGlobalDomain.KeyRepeat = 2;
          };
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "symphoneice"
          ];
          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
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
          # This is a Nix module for Macintosh computers (“darwin”)
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
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
}
