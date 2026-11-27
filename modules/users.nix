{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.jbm = {
    isNormalUser = true;
    description = "JBM";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = [
    (pkgs.python3.withPackages (ps: [
      ps.dbus-python
    ]))
  ];
}
