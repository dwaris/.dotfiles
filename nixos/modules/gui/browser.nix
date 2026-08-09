{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (brave.override {
      enableVideoAcceleration = true;
      enableVulkan = true;
    })
    firefox
  ];
}
