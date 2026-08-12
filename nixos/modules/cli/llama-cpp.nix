{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    llama-cpp-rocm
    pi-coding-agent
  ];

  networking.firewall = {
    allowedTCPPorts = [ 9931 ];
  };
}
