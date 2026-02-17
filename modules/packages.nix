{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # code Lsp
    superhtml
    vscode-langservers-extracted
    nodePackages.postcss
    ansible-language-server
    yaml-language-server
    pyright
    ruff
    nixfmt-rfc-style
    gopls
    gotools
    goimports-reviser
    mkalias
    stylua
    shfmt
    nil
    dockerfile-language-server
    docker-compose-language-service
    lua-language-server
    typescript
    typescript-language-server
    tailwindcss-language-server
    simple-completion-language-server
    tombi
    yamlfmt
    marksman
    bash-language-server
    # language package manager
    cargo
    bun
    uv
    pnpm
    # language environment
    go
    lua
    # tool
    docker
    exercism
    git
    git-lfs
    fzf
    lazygit
    wget
    devenv
    bashInteractive
    direnv
    lazyjj
    jujutsu
    jjui
    ffmpeg
    jq
    poppler
    fd
    ripgrep
    zoxide
    resvg
    tree
  ];

  environment.shellAliases = {
  };
}
