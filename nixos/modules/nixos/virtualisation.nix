{ config, pkgs, ... }: {
    programs.virt-manager.enable = true;

    virtualisation = {
        libvirtd = {
        enable = true;
        qemuOvmf = true;
        qemuSwtpm = true;
        qemuOvmfPackage = pkgs.OVMFFull;
        };
    };

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    environment.systemPackages = with pkgs; [ virt-manager win-virtio ];
    users.users.dwaris = {
      extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];
    };
}
