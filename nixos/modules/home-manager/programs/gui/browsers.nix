{  pkgs,  config, ...}: {
    programs = {
    chromium = {
        enable = true;
        package = (pkgs.chromium.override { enableWideVine = true; });
        extensions = [
            "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
            "nngceckbapebfimnlniiiahkandclblb" # bitwarden
            "lanfdkkpgfjfdikkncbnojekcppdebfp" # canvas fingerprint defender
            "mdlbikciddolbenfkgggdegphnhmnfcg" # netflix 1080p new?
            "ponfpcnoihfmfllpaingbgckeeldkhle" # block yt-shorts
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
