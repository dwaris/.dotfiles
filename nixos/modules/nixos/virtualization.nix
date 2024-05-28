{ config, pkgs, ... }: {
    programs.virt-manager.enable = true;

    virtualisation = {
        libvirtd = {
            enable = true;
        };
    };

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    environment.systemPackages = with pkgs; [ virt-manager ];
    users.users.dwaris = {
      extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];
    };
}
