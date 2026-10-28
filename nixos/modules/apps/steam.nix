{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        export PROTON_ENABLE_WAYLAND=1
      '';
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    protontricks.enable = true;
  };
}
