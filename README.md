# nix-darwin Configuration

This repository is a macOS system configuration managed with
[nix-darwin](https://github.com/nix-darwin/nix-darwin), Home Manager, and
Homebrew.

It is written for an Apple Silicon Mac, but the structure is meant to be easy to
adapt for another user or machine.

## What This Manages

- System packages from `nixpkgs`
- Homebrew formulae, casks, and taps
- Home Manager dotfiles
- Fonts
- macOS system defaults
- Shell/editor/tool configuration for zsh, Helix, Yazi, and Jujutsu
- A small `devenv` development shell

## Repository Layout

```text
.
|-- flake.nix
|-- flake.lock
|-- modules/
|   |-- packages.nix
|   |-- homebrew.nix
|   |-- fonts.nix
|   |-- system-defaults.nix
|   `-- home-manager.nix
|-- config/
|   |-- .zshrc
|   |-- .gitconfig
|   |-- helix/
|   |-- yazi/
|   `-- jj/
|-- devenv.nix
|-- devenv.yaml
`-- README.md
```

## Before You Use It

This repo still contains machine-specific values. Change these before applying
it on another Mac:

- `flake.nix`
  - `darwinConfigurations."SymphoneIcedeMacBook-Pro"`
  - `system.primaryUser = "symphoneice"`
  - `nix.settings.trusted-users`
  - `nix-homebrew.user`
  - `nixpkgs.hostPlatform` if you are not on Apple Silicon
- `modules/home-manager.nix`
  - `user = "symphoneice"`
  - `homeDirectory = "/Users/${user}"`
- `config/.gitconfig`
  - Git name and email

You can get your current host name with:

```bash
scutil --get LocalHostName
```

You can get your current macOS username with:

```bash
id -un
```

## Install Nix

Install Nix first. The official guide is:

```text
https://nix.dev/install-nix
```

On macOS, the standard installer is:

```bash
curl -L https://nixos.org/nix/install | sh
```

Restart your shell after installation, or follow the installer's instructions to
load Nix into the current shell.

## Clone The Repository

This repository should be cloned to `/etc/nix-darwin`.

Several Home Manager file links currently use absolute paths under
`/etc/nix-darwin/config`, so cloning to another directory requires editing those
paths first.

```bash
cd /etc
sudo git clone https://github.com/SymphonyIceAttack/nix-darwin.git
sudo chown -R "$(id -un):$(id -gn)" /etc/nix-darwin
cd /etc/nix-darwin
```

On macOS, `/etc` usually resolves internally to `/private/etc`, so
`/etc/nix-darwin` and `/private/etc/nix-darwin` normally refer to the same
directory.

## Adapt The Configuration

Replace the host name and username before switching:

```bash
host="$(scutil --get LocalHostName)"
user="$(id -un)"
```

Then edit these files manually:

```bash
$EDITOR flake.nix modules/home-manager.nix config/.gitconfig
```

Make sure the flake output name matches your host:

```nix
darwinConfigurations."<your-host-name>" = nix-darwin.lib.darwinSystem {
```

Make sure the user values match your macOS account:

```nix
system.primaryUser = "<your-user>";
nix-homebrew.user = "<your-user>";
```

## First Switch

For the first activation, run nix-darwin through Nix:

```bash
sudo nix run nix-darwin/master#darwin-rebuild \
  --extra-experimental-features "nix-command flakes" \
  -- switch --flake .#$(scutil --get LocalHostName) --impure
```

This repo currently expects `--impure` because some Home Manager file links use
absolute paths under `/etc/nix-darwin`.

## Normal Usage

After the first switch, use:

```bash
sudo darwin-rebuild switch --flake .#$(scutil --get LocalHostName) --impure
```

If your shell is already inside the repo and the host name matches the default
flake output, this shorter form may also work:

```bash
sudo darwin-rebuild switch --impure
```

## Common Tasks

Update flake inputs:

```bash
nix flake update
```

Build without switching:

```bash
darwin-rebuild build --flake .#$(scutil --get LocalHostName) --impure
```

Format Nix files:

```bash
nixfmt flake.nix modules/*.nix devenv.nix
```

Enter the development shell:

```bash
devenv shell
```

Enable direnv for this repo:

```bash
direnv allow
```

## Editing Packages And Apps

Nix packages are declared in:

```text
modules/packages.nix
```

Homebrew formulae, casks, and taps are declared in:

```text
modules/homebrew.nix
```

Dotfiles managed by Home Manager live under:

```text
config/
```

After changing any of these, run:

```bash
sudo darwin-rebuild switch --flake .#$(scutil --get LocalHostName) --impure
```

## Troubleshooting

### Git Says The Repository Is Not Owned By The Current User

Error example:

```text
error: opening Git repository "/private/etc/nix-darwin":
repository path '/private/etc/nix-darwin' is not owned by current user
```

Fix ownership first:

```bash
sudo chown -R "$(id -un):$(id -gn)" /private/etc/nix-darwin
```

If Git still blocks the repo, mark it as safe:

```bash
git config --global --add safe.directory /private/etc/nix-darwin
```

### Jujutsu Or jjui Reports Permission Denied

If `jj` or `jjui` reports permission errors inside `.jj` or
`~/.config/jj/repos`, some files were probably created by `root`.

Fix the repo metadata:

```bash
sudo chown -R "$(id -un):$(id -gn)" /private/etc/nix-darwin/.jj
```

Fix the user-level jj config cache:

```bash
sudo chown -R "$(id -un):$(id -gn)" "$HOME/.config/jj"
```

### Homebrew Fails During switch

The Homebrew step runs from `modules/homebrew.nix`. If a cask download fails,
you can temporarily remove that cask from the list and switch again.

Useful commands:

```bash
brew info --cask <name>
brew install --cask <name>
brew postinstall <formula>
```

### Home Manager Cannot Link A File

If Home Manager says a target already exists, move the existing file away and
switch again:

```bash
mv ~/.zshrc ~/.zshrc.backup
sudo darwin-rebuild switch --flake .#$(scutil --get LocalHostName) --impure
```

## Notes

- This configuration uses `nixpkgs-unstable`.
- Homebrew is managed declaratively through nix-darwin.
- Home Manager links source files from `config/` into the user's home directory.
- Keep secrets out of Git. Environment files such as `.env` should stay
  ignored.
