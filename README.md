# Install nix
https://nix.dev/install-nix
## Macos
`curl -L https://nixos.org/nix/install | sh`

# clone
`git clone https://github.com/SymphonyIceAttack/nix-darwin/new/main`
# install
`sudo nix run nix-darwin/master#darwin-rebuild
`
use your own MacName
# once switch
`sudo nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --impure`
# switch
`darwin-rebuild switch --impure
`
