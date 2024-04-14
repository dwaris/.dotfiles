{ config, pkgs, ... }: {
    programs.starship.enable = true;

    programs.starship.settings = {
        scan_timeout = 10;
        character = {
            success_symbol = ''[\$](bold green)'';
            error_symbol = ''[\$](bold red)'';
        };
        username = {
            style_user = "bold purple";
            style_root = "bold red";
            format = "[$user]($style)";
            disabled = false;
            show_always = true;
        };
        hostname = {
            ssh_only = false;
            format = "[@](bolde)[$hostname](bold yellow) ";
            disabled = false;
        };
        cmd_duration.disabled = true;
    };
}
