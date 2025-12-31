# shout down filevalut (关闭文件保险柜)
# Install nix
https://nix.dev/install-nix
## Macos
`curl -L https://nixos.org/nix/install | sh`
# directory
`cd /etc`
# clone
`git clone https://github.com/SymphonyIceAttack/nix-darwin.git`
# chown
`sudo chown $(id -nu):$(id -ng) /etc/nix-darwin`
# change SymxxxMac-Pro to use your own MacName in flake.nix
`sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix`
# once switch
`sudo nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --impure`
# switch
`sudo darwin-rebuild switch --impure
`
# error list
##  not own your with  git clone error
`darwin-rebuild switch --impure
building the system configuration...
error:
… while fetching the input 'git+file:///private/etc/nix-darwin'
 error: opening Git repository "/private/etc/nix-darwin": repository path '/private/etc/nix-darwin' is not owned by current user`

## use
`sudo git config --global --add safe.directory /private/etc/nix-darwin`
## user permission error
`Error: Failed getting initial status
Caused by:
    Internal error: Failed to load an operation
    Caused by:
    1: Error when reading object e7231a49d5045687a764baf793e014ef0fb813efa573b6c804081d6d0a864d4f430d9b7d52379c4e8dd1fd59cd39925ca9bb426d576b754df3d977ccfb5eecaf of type operation
    2: Permission denied (os error 13)`
## use
`cd ..`
`sudo chown -R symphoneice nix-darwin/`
