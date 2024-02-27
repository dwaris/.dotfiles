{ config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/default.nix
    ../../modules/home-manager/gnu-radio.nix
    ../../modules/home-manager/encoding.nix
    ../../modules/home-manager/languages.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dwaris";
  home.homeDirectory = "/home/dwaris";

  nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
        microsoft-edge
        floorp
        neovide
        love
];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "floorp";
    TERMINAL = "alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
