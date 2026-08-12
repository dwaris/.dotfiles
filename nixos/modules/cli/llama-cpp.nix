{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    llama-cpp-rocm
    pi-coding-agent
  ];

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-rocm;
    openFirewall = true;
  };
}
