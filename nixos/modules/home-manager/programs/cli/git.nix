{  pkgs,  config, ...}: {
    programs.git = {
        enable = true;

        userName = "dwaris";
        userEmail = "malina@rhrk.uni-kl.de";
        signing.key	= null;
        signing.signByDefault = true;
  };
}
