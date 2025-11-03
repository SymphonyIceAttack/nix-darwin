export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
export PNPM_HOME="/Users/symphoneice/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
