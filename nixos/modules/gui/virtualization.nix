{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
        qemu = {
          vhostUserPackages = with pkgs; [ virtiofsd ];
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
          swtpm.enable = true;
        };
    };
  };

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
  environment.systemPackages = with pkgs; [ virt-manager ];
  users.users.dwaris = {
    extraGroups = [
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
    ];
  };
}
