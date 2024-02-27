{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        (gnuradio.override {
        extraPackages = with gnuradioPackages; [
            osmosdr
        ];
        extraPythonPackages = with gnuradio.python.pkgs; [
            numpy
        ];
        })       
    ];
}
