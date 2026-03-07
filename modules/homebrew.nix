{ ... }:
{
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
      "crush"
      "tesseract-lang"
      "tesseract"
      "poppler"
    ];
    casks = [
      {
        name = "claude-code";
        greedy = true;
      }
      {
        name = "orbstack";
        greedy = true;
      }
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
      {
        name = "charmbracelet/tap";
        clone_target = "https://github.com/charmbracelet/homebrew-tap";
        force_auto_update = true;
      }
    ];
  };
}
