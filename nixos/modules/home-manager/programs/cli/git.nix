{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "dwaris";
    userEmail = "malina@rhrk.uni-kl.de";
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
