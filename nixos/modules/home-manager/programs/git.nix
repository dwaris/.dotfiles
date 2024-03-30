{  pkgs,  config, ...}: {
    #home.packages = with pkgs; [
    #    gh
    #];

    programs.git = {
        enable = true;

        userName = "dwaris";
        userEmail = "malina@rhrk.uni-kl.de";
  };

}
