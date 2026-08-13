{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    llama-cpp-rocm
  ];

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
  };
}
