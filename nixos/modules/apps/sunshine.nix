{...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = false;
  };

  users.users.dwaris.extraGroups = [
    "uinput"
    "input"
  ];
}
