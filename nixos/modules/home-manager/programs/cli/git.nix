{  pkgs,  config, ...}: {
    programs.git = {
        enable = true;

        userName = "dwaris";
        userEmail = "dwaris@itclowd.de";
        signing.key	= null;
        signing.signByDefault = true;
  };
}
