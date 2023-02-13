{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      pcmanfm
      nitch
      neovim
      htop
      alsa-utils
      xdg-utils
      feh
      volumeicon
      ;
  };
}
