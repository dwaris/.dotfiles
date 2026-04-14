{
  config,
  pkgs,
  lib,
  ...
}:{
  boot.blacklistedKernelModules = [ "dccp" "sctp" "rds" "tipc" ];
  boot.tmp.useTmpfs = true;

  security.auditd.enable = true;

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 1;
    "kernel.sysrq" = 16;

    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;

    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
  };

  services.openssh = {
   settings = {
     LogLevel = "VERBOSE";
      MaxAuthTries = 3;
      MaxSessions = 2;
      TCPKeepAlive = "no";
      ClientAliveCountMax = 2;
      AllowTcpForwarding = "no";
      AllowAgentForwarding = "no";
    };
  };


}