{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.yashraj = {
    description = "Yash Raj";
    initialPassword = "nixos";
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
        "input"
      ]
      ++ ifTheyExist [
        "network"
        "networkmanager"
        "git"
      ];

    packages = [pkgs.home-manager];
  };

  home-manager.users.yashraj = import ../../../home/yashraj;
}
