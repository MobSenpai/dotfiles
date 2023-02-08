{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Shared configuration across all machines.
    ../shared
    ../shared/users/yashraj.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];

    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["btrfs"];
    };

    kernelModules = ["acpi_call"];

    kernelParams = [
      # "i915.force_probe=46a6"
      # "i915.enable_psr=0"
      # "i915.enable_guc=2"
      # "i8042.direct"
      # "i8042.dumbkbd"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot.enable = false;

      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "1366x768";
      };
    };
  };

  networking = {
    hostName = "acer";
    networkmanager.enable = true;
    useDHCP = false;
  };

  # Windows wants hardware clock in local time instead of UTC
  # time.hardwareClockInLocalTime = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+awesome";
        lightdm.enable = true;
      };

      dpi = 96;
      exportConfiguration = true;
      layout = "us";

      windowManager = {
        awesome = {
          enable = true;
          package = inputs.nixpkgs-f2k.packages.${pkgs.system}.awesome-git;
          luaModules = lib.attrValues {
            inherit (pkgs.luaPackages) lgi;
          };
        };
      };
    };

    # btrfs.autoScrub.enable = true;
    acpid.enable = true;
    # thermald.enable = true;
    # upower.enable = true;

    # tlp = {
    #   enable = true;
    #   settings = {
    #     START_CHARGE_THRESH_BAT0 = 0;
    #     STOP_CHARGE_THRESH_BAT0 = 80;
    #   };
    # };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      # extraPackages = with pkgs; [
      #   # intel-compute-runtime
      #   # intel-media-driver # iHD
      #   libva
      #   libvdpau
      #   # libvdpau-va-gl
      #   # (vaapiIntel.override {enableHybridCodec = true;}) # i965 (older but works better for Firefox/Chromium)
      #   # vaapiVdpau
      # ];
    };

    # cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    # pulseaudio.enable = false;

    # bluetooth = {
    #   enable = true;
    #   package = pkgs.bluez;
    # };
  };

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment = {
    systemPackages = lib.attrValues {
      inherit
        (pkgs)
        # libsForQt5.qtstyleplugins
        
        acpi
        # brightnessctl
        
        libva
        libvdpau
        # libva-utils
        
        # ocl-icd
        
        # vulkan-tools
        
        ;
    };

    variables = {
      # GDK_SCALE = "2";
      # GDK_DPI_SCALE = "0.5";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05"; # DONT TOUCH THIS
}
