{
  config,
  pkgs,
  ...
}: let
  user = "dwaris";
in {
  environment.systemPackages = with pkgs; [
    mpc
    rmpc
  ];
  services.mpd = {
    enable = true;
    user = user;
    settings = {
      music_directory = "/home/${user}/Music";
      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire Native";
          mixer_type = "software";
        }
      ];
    };
  };
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${user}.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  };
}
