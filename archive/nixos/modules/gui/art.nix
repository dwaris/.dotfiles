{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    inkscape
    gimp
    krita
    pixelorama
  ];
}
