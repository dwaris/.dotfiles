{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (brave-origin.override {
      enableVideoAcceleration = true;
    })
    firefox
  ];
}
