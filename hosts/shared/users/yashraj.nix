{
  pkgs,
  config,
  lib,
  outputs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.yashraj = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Yash Raj";
    initialPassword = "nixos";
    extraGroups =
      [
        "wheel"
        # "networkmanager"
        "video"
        "audio"
        # "nix"
        # "systemd-journal"
      ]
      ++ ifTheyExist [
        "network"
        "git"
        # "mysql"
        # "docker"
        # "libvirtd"
      ];

    uid = 1000;
    packages = [pkgs.home-manager];
  };

  home-manager.users.rxyhn = import ../../../home/rxyhn/${config.networking.hostName};
}
