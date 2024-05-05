{  pkgs,  config, ...}: {
    programs = {
    chromium = {
        enable = true;
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
