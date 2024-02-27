{ config, pkgs, inputs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dwaris = {
    isNormalUser = true;
    description = "dwaris";
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "dwaris" = import ./home.nix;
    };
  };
}
