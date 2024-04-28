{  pkgs,  config, ...}: {
    programs = {
    chromium = {
        enable = true;
#        commandLineArgs = ["--enable-features=UseOzonePlatform --ozone-platform=wayland"];
        extensions = [
            "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
            "nngceckbapebfimnlniiiahkandclblb" # bitwarden
            "lanfdkkpgfjfdikkncbnojekcppdebfp" # canvas fingerprint defender
            "mdlbikciddolbenfkgggdegphnhmnfcg" # netflix 1080p new?
            "efobhjmgoddhfdhaflheioeagkcknoji" # vertical tabs
            "ldgfbffkinooeloadekpmfoklnobpien" # raindrop.io
            "bkkmolkhemgaeaeggcmfbghljjjoofoh" # catppuccin mocha theme
        ];
    };

    #firefox = {
    #    enable = true;
    #};
  };

    home.packages = with pkgs; [
        floorp
        tor-browser
        #(vivaldi.override {
        #    proprietaryCodecs = true;
        #    enableWidevine = true;
        #})
        #microsoft-edge
    ];
}
