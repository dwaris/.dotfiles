{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    package = pkgs.steam.override {
      extraArgs = "-pipewire-dmabuf";
      extraProfile = ''
        export PROTON_ENABLE_WAYLAND=1
        export GBM_BACKENDS_PATH=/run/opengl-driver/lib/gbm
      '';
    };
    protontricks.enable = true;
  };
}
