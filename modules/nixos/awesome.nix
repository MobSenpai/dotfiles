{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.xserver.windowManager.awesome;

  # reinventing the wheel of the default awesomewm module
  getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.luajit.luaversion}";
  makeSearchPath = lib.concatMapStrings (
    path:
      " --search "
      + (getLuaPath path "share")
      + " --search "
      + (getLuaPath path "lib")
  );

  luaModules = lib.attrValues {
    inherit
      (pkgs.luajitPackages)
      lgi
      # ldbus
      
      # luadbi-mysql
      
      # luaposix
      
      ;
  };
in {
  options = {
    services.xserver.windowManager.awesome = {
      enable = mkEnableOption (lib.mdDoc "Awesome window manager");
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      dpi = 96;
      exportConfiguration = true;
      # xkbOptions = "caps:escape";

      displayManager = {
        defaultSession = "none+awesome";
        lightdm.enable = true;
      };

      windowManager.session =
        singleton
        {
          name = "awesome";
          start = ''
            ${pkgs.awesome-git-luajit}/bin/awesome ${makeSearchPath luaModules} &
            waitPID=$!
          '';
        };
    };

    environment.systemPackages = lib.attrValues {
      inherit
        (pkgs)
        awesome-git-luajit
        pcmanfm
        feh
        volumeicon
        clipmenu
        ;
    };
  };
}
