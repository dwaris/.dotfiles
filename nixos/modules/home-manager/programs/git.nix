{  pkgs,  config, ...}: {
    #home.packages = with pkgs; [
    #    gh
    #];

    programs.git = {
        enable = true;

        userName = "dwaris";
        userEmail = "dwaris@itclowd.de";
  };

}
