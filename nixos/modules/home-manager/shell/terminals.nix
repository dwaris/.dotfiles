{ pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "/home/dwaris/.dotfiles/nixos/modules/home-manager/shell/themes/alacritty/catppuccin/catppuccin-mocha.toml"
      ];
      live_config_reload = true;
      window = {
        startup_mode = "Maximized";
        decorations = "full";
        opacity = 1.0;
        dynamic_title = true;
      };

      shell = {
        args = [
          "-l"
          "-c"
          "tmux attach || tmux"
        ];
        program = "${pkgs.bash}/bin/bash";
      };

      font = {
        size = 12;
      };
    };
  };
}
