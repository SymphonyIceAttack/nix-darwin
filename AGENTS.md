# AGENTS.md - Guide for Working in This Repository

This document provides essential information for AI agents working with this nix-darwin configuration repository.

## Project Overview

This is a **nix-darwin** configuration repository for macOS system configuration management. It manages:
- System packages via Nix and Homebrew
- User-level configurations via Home Manager
- Editor configurations (Helix, Yazi, JJ)
- Shell environment (zsh with starship, direnv, nvm)
- Application casks via Homebrew
- Development environment via devenv

**Host Name**: SymphoneIcedeMacBook-Pro
**Primary User**: symphoneice
**Platform**: aarch64-darwin (Apple Silicon)

## Essential Commands

### Apply System Configuration

```bash
# Build and switch (requires sudo)
sudo darwin-rebuild switch --impure

# Or for initial setup/first switch
sudo nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --impure
```

### Development Shell

```bash
# Enter devenv shell
devenv shell

# With automatic environment loading
direnv allow
```

### Package Search

```bash
# Search available packages in nixpkgs
nix-env -qaP | grep <package-name>
```

### Git Repository Permissions

If you encounter permission errors with git operations:
```bash
sudo git config --global --add safe.directory /private/etc/nix-darwind
sudo chown -R symphoneice nix-darwin/
```

## Repository Structure

```
/etc/nix-darwin/
├── flake.nix              # Main Nix flake configuration
├── devenv.yaml            # Devenv configuration schema
├── devenv.nix             # Devenv environment definition
├── README.md              # Setup instructions and error troubleshooting
├── .crush.json            # Crush CLI configuration
├── .env.crush             # Environment variables (API keys, settings)
├── .envrc                 # Direnv configuration
├── .gitignore
├── .gitconfig             # Git user configuration
├── modules/               # Modular Nix configuration files
│   ├── packages.nix       # System packages (environment.systemPackages)
│   ├── homebrew.nix       # Homebrew configuration (brews, casks, taps)
│   ├── fonts.nix          # Font packages
│   ├── system-defaults.nix # macOS system preferences
│   └── home-manager.nix   # Home Manager user configuration
├── config/                # User-level configurations (linked via home-manager)
│   ├── .zshrc             # Zsh shell configuration
│   ├── .gitconfig         # Git configuration
│   ├── .warp/             # Warp terminal theme
│   ├── helix/             # Helix editor configuration
│   │   ├── config.toml    # Editor settings
│   │   ├── languages.toml # Language server mappings
│   │   ├── themes/        # Editor themes
│   │   └── snippets/      # Editor snippets
│   ├── jj/                # Jujutsu VCS configuration
│   │   └── config.toml
│   └── yazi/              # Yazi file manager configuration
│       ├── init.lua
│       ├── keymap.toml
│       ├── package.toml
│       ├── yazi.toml
│       └── plugins/
└── result                 # Nix build output (symlink)
```

## Configuration Patterns

### Nix Module Structure

The flake.nix defines a `configuration` module with standard nix-darwin structure:

- `environment.systemPackages` - System-wide packages installed via Nix
- `environment.shellAliases` - Shell aliases
- `fonts.packages` - Nerd fonts
- `homebrew` - Homebrew configuration (brews, casks, taps, masApps)
- `system.defaults` - macOS system preferences
- `nix.settings` - Nix daemon configuration

### Home Manager Integration

User-level configurations are managed through home-manager modules and linked via `home.file` entries:

```nix
home-manager.users.symphoneice = { pkgs, ... }:
{
  home.file = {
    ".warp".source = /etc/nix-darwin/config/.warp;
    ".zshrc".source = /etc/nix-darwin/config/.zshrc;
    ".gitconfig".source = /etc/nix-darwin/config/.gitconfig;
    ".config/helix".source = /etc/nix-darwin/config/helix;
    ".config/yazi".source = /etc/nix-darwin/config/yazi;
    ".config/jj".source = /etc/nix-darwin/config/jj;
  };
};
```

### Homebrew Configuration

```nix
homebrew = {
  enable = true;
  brews = [ "mas", "python", "neovim", "nvm", "imagemagick", "helix", ... ];
  casks = [
    { name = "claude-code"; greedy = true; }
    { name = "orbstack"; greedy = true; }
    ...
  ];
  masApps = { };
  onActivation = {
    cleanup = "zap";
    autoUpdate = true;
    upgrade = true;
  };
  taps = [
    { name = "lihaoyun6/tap"; clone_target = "..."; force_auto_update = true; }
    ...
  ];
};
```

## Naming Conventions

- **Host Names**: Use `SymphoneIcedeMacBook-Pro` pattern (computes from `scutil --get LocalHostName`)
- **Users**: `symphoneice` (primary user throughout configuration)
- **Nix Channels**: `nixpkgs-unstable` for nixpkgs, `nix-darwin/master` for nix-darwin
- **File Names**: Lowercase with hyphens for config files, TOML for editor configs

## Testing and Validation

### Check Nix Configuration Syntax

```bash
# Validate flake syntax
nix fmt flake.nix

# Format nix files
nixfmt-rfc-style flake.nix
```

### Dry Run Build

```bash
# Preview build without switching
sudo darwin-rebuild build --impure
```

### Verify Homebrew

```bash
# Update and upgrade homebrew
brew update && brew upgrade
```

## Important Gotchas

### 1. `--impure` Flag Required

All `darwin-rebuild` commands require the `--impure` flag because this configuration uses:
- `flake.nix` references external files (config directory)
- Home Manager integration with system-level modules

### 2. Host Name Must Match

The flake.nix contains a hardcoded host name `SymphoneIcedeMacBook-Pro`. When setting up on a new machine:
```bash
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```

### 3. Git Repository Permissions

After cloning to /etc, you may need to fix ownership:
```bash
sudo chown -R symphoneice nix-darwin/
sudo git config --global --add safe.directory /private/etc/nix-darwin
```

### 4. Home Manager State Version

- System stateVersion: 6 (nix-darwin)
- Home stateVersion: "25.05" (home-manager)

### 5. Editor Configuration Linking

Helix, Yazi, and JJ configurations are linked via home-manager, not installed directly. Changes to `config/helix/`, `config/yazi/`, and `config/jj/` will be applied after running `darwin-rebuild switch`.

### 6. Yazi CWD Handling

The `.zshrc` includes a `y()` function that properly handles Yazi's cwd file changes, allowing directory navigation within Yazi to persist in the shell.

## Crush CLI Configuration

Located in `.crush.json` with the following setup:

### Available Models
- **MinMax** (MiniMax-M2.1) - Primary reasoning model
- **Gemini** (gemini-3-flash-preview) - Alternative model

### Available Tools
- bash, grep, ls, view, edit, write, download
- biome, pnpm
- context7 (MCP) - Documentation lookup
- MiniMax MCP (MCP) - AI generation (image, audio, video)
- MiniMax-Code (MCP) - Code assistance
- chrome-devtools (MCP) - Browser automation

### Disabled Tools
- npm, convert, python3

### LSP Configuration
- Go: `gopls`
- Nix: `nil`
- TypeScript: `typescript-language-server`
- Biome: `biome lsp-proxy`

### Environment Variables

Located in `.env.crush`:
- `EDITOR=hx` (Helix)
- API keys for MinMax, Gemini, Context7
- Custom base URLs for API proxies

## Development Workflow

1. **Edit configuration files** (modules/*.nix, devenv.nix, or config/ subdirectories)
2. **Test changes** with `sudo darwin-rebuild build --impure`
3. **Apply changes** with `sudo darwin-rebuild switch --impure`
4. **Verify** new packages/applications are available

For editor configurations in `config/helix/`, `config/yazi/`, `config/jj/`:
1. Edit the source files in `config/`
2. Run `darwin-rebuild switch` to apply changes
3. The symlinks in `~/.config/` will be updated

For system configurations in `modules/`:
1. Edit the appropriate module file (packages.nix, homebrew.nix, etc.)
2. Run `darwin-rebuild switch --impure` to apply changes
3. Changes take effect immediately

## Additional Resources

- [nix-darwin Wiki](https://github.com/nix-darwin/nix-darwin)
- [Nix Manual](https://nix.dev/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Devenv Documentation](https://devenv.sh/)
