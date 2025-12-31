{ ... }:
{
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
}
