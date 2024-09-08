{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
      package = (pkgs.chromium.override { enableWideVine = true; });
      extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite (R.I.P. MV2 and Fuck off Google)
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "lanfdkkpgfjfdikkncbnojekcppdebfp" # canvas fingerprint defender
        "mdlbikciddolbenfkgggdegphnhmnfcg" # netflix 1080p new?
        "ponfpcnoihfmfllpaingbgckeeldkhle" # block yt-shorts
        #"efobhjmgoddhfdhaflheioeagkcknoji" # vertical tabs
        "ldgfbffkinooeloadekpmfoklnobpien" # raindrop.io
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # catppuccin mocha theme
      ];
    };
    firefox = {
      enable = true;
      profiles = {
        dwaris = {
          id = 0; # The profile ID, 0 is the default profile
          name = "dwaris";
        };
      };
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        Certificates = {
          Install = [ "/etc/ssl/certs/root_ca.crt" ];
        };

        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
  };

  home.packages = with pkgs; [
    #floorp
    tor-browser
    #(vivaldi.override {
    #    proprietaryCodecs = true;
    #    enableWidevine = true;
    #})
    #microsoft-edge
  ];
}
