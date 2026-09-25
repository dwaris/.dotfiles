{...}: {
  networking.firewall.enable = true;
  networking.nftables.enable = true;

  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "ax25"
    "netrom"
    "rose"
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
    "vivid"
    "firewire-core"
  ];

  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;

  boot.kernelParams = [
    "slab_nomerge"
    "page_alloc.shuffle=1"
    "randomize_kstack_offset=on"
    "vsyscall=none"
    "debugfs=off"
  ];

  boot.kernel.sysctl = {
    "dev.tty.ldisc_autoload" = 0;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.protected_symlinks" = 1;
    "fs.protected_hardlinks" = 1;
    "fs.suid_dumpable" = 0;

    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.sysrq" = 244;
    "kernel.yama.ptrace_scope" = 1;
    "kernel.randomize_va_space" = 2;
    "kernel.panic_on_oops" = 1;
    "kernel.perf_event_paranoid" = 2;

    "net.core.bpf_jit_harden" = 2;

    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;

    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    "net.ipv4.conf.all.drop_gratuitous_arp" = 1;
    "net.ipv4.conf.all.arp_ignore" = 2;
    "net.ipv4.conf.all.arp_filter" = 1;

    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.ip_local_port_range" = "32768 65535";

    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
  };

  systemd.coredump.enable = false;
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "core";
      value = "0";
    }
  ];

  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [
      "time.cloudflare.com"
      "ptbtime1.ptb.de"
      "ntppool1.time.nl"
      "nts.netnod.se"
    ];
  };

  security.protectKernelImage = true;

  services.openssh = {
    enable = false;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      LogLevel = "VERBOSE";
      MaxAuthTries = 3;
      MaxSessions = 2;
      TCPKeepAlive = "no";
      ClientAliveCountMax = 2;
      AllowTcpForwarding = "no";
      AllowAgentForwarding = "no";
    };
    extraConfig = "TrustedUserCAKeys ${../../certs/ca_key.pub}";
  };
}
