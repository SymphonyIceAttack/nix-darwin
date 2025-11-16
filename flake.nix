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
            # code Lsp
            pkgs.superhtml
            pkgs.vscode-langservers-extracted
            pkgs.nodePackages.postcss
            pkgs.ansible-language-server
            pkgs.yaml-language-server
            pkgs.pyright
            pkgs.ruff
            pkgs.nixfmt-rfc-style
            pkgs.gopls
            pkgs.gotools
            pkgs.goimports-reviser
            pkgs.mkalias
            pkgs.stylua
            pkgs.shfmt
            pkgs.nil
            pkgs.dockerfile-language-server
            pkgs.docker-compose-language-service
            pkgs.lua-language-server
            pkgs.typescript
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
            pkgs.simple-completion-language-server
            pkgs.tombi
            pkgs.yamlfmt
            pkgs.marksman
            # language package manager
            pkgs.cargo
            pkgs.bun
            pkgs.pnpm
            pkgs.uv
            # language environment
            pkgs.go
            pkgs.lua
            # tool
            pkgs.gemini-cli
            pkgs.exercism
            pkgs.git
            pkgs.git-lfs
            pkgs.fzf
            pkgs.lazygit
            pkgs.wget
            pkgs.devenv
            pkgs.bashInteractive
            pkgs.direnv
            pkgs.lazyjj
            pkgs.jujutsu
            pkgs.ffmpeg
            pkgs.jq
            pkgs.poppler
            pkgs.fd
            pkgs.ripgrep
            pkgs.fzf
            pkgs.zoxide
            pkgs.resvg
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
              "imagemagick"
              "helix"
              "sevenzip"
              "yazi"
              "starship"
              "mole"
            ];
            casks = [
              {
                name = "ghostty";
                greedy = true;
              }
              {
                name = "quickrecorder";
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
              {
                name = "lihaoyun6/tap";
                clone_target = "https://github.com/lihaoyun6/homebrew-tap";
                force_auto_update = true;
              }
              {
                name = "tw93/tap";
                clone_target = "https://github.com/tw93/homebrew-tap";
                force_auto_update = true;
              }

            ];
          };
          system.primaryUser = "symphoneice";
          system.defaults = {
            dock.autohide = true;
            dock.persistent-apps = [
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
            NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
            trackpad = {
              TrackpadThreeFingerDrag = true;
            };
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
            home-manager.verbose = true;
            users.users.symphoneice = {
              name = "symphoneice";
              home = "/Users/symphoneice";
            };
            home-manager.users.symphoneice =
              { pkgs, ... }:
              {
                home.stateVersion = "25.05";
                home.homeDirectory = "/Users/symphoneice";
                home.username = "symphoneice";
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
        ];
      };
    };
}
