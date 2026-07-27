{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mesen
  ];
}
