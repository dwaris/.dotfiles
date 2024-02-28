{ config, pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dwaris = {
    isNormalUser = true;
    description = "dwaris";
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}
