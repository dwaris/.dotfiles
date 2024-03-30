{  pkgs,  config, ...}: {
  programs = {
    chromium = {
      enable = true;
      commandLineArgs = ["--enable-features=UseOzonePlatform --ozone-platform=wayland"];
      extensions = [
         "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      ];
    };

    firefox = {
      enable = true;
    };
  };

    home.packages = with pkgs; [
        firefox-bin
        floorp
        (vivaldi.override {
            proprietaryCodecs = true;
            enableWidevine = true;
        })
        tor-browser
        microsoft-edge
    ];
}
