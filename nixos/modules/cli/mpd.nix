{
  config,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpc
    rmpc
  ];
  services.mpd = {
    enable = true;
    user = username;
    settings = {
      music_directory = "/home/${username}/Music";
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
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${username}.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  };
}
