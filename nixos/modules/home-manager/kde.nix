{ config, pkgs, lib, ... }: {
    home.sessionVariables = {
        SSH_ASKPASS_REQUIRE="prefer";
    };
}