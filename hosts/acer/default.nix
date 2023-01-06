{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix

    # Shared configuration across all machines.
    ../shared
    ../shared/users/yashraj.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # Make modules available to modprobe
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];

    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["btrfs"];
    };

    # Load modules on boot
    kernelModules = ["acpi_call"];

    kernelParams = [
      "i915.force_probe=46a6"
      "i915.enable_psr=0"
      "i915.enable_guc=2"
      "i8042.direct"
      "i8042.dumbkbd"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      # systemd-boot.enable = true;
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
    networkmanager.enable = true;
    useDHCP = false;
  };

  # Slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;

  # Windows wants hardware clock in local time instead of UTC
  time.hardwareClockInLocalTime = true;

  services = {
    xserver = {
      enable = true;

      windowManager = {
        awesome = {
          enable = true;
          luaModules = lib.attrValues {
            inherit (pkgs.luaPackages) lgi;
          };
        };
      };

      dpi = 96;

      displayManager = {
        defaultSession = "none+awesome";
        lightdm.enable = true;
        #sessionPackages = [pkgs.awesome];
      };
    };

    # tlp = {
    #   enable = true;
    #   settings = {
    #     START_CHARGE_THRESH_BAT0 = 0;
    #     STOP_CHARGE_THRESH_BAT0 = 85;
    #   };
    # };

    # btrfs.autoScrub.enable = true;
    # acpid.enable = true;
    # thermald.enable = true;
    # upower.enable = true;
  };

  hardware = {
    opengl = with pkgs; {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # intel-compute-runtime
        # intel-media-driver
        # libva
        # vaapiIntel
        # vaapiVdpau
      ];
    };

    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
    # bluetooth = {
    #   enable = true;
    #   package = pkgs.bluez;
    # };
  };

  # nixpkgs.config.packageOverrides = pkgs: {
  #   vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  # };

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  xdg.portal = {
    enable = true;
    # wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
  };

  #   security = {
  #     pam.services.swaylock = {
  #       text = ''
  #         auth include login
  #       '';
  #     };
  #   };

  environment = {
    systemPackages = with pkgs; [
      acpi
      libsForQt5.qtstyleplugins
    ];

    variables = {};
    sessionVariables = {};
  };

  #   virtualisation = {
  #     docker.enable = true;

  #     libvirtd = {
  #       enable = true;
  #       qemu = {
  #         package = pkgs.qemu_kvm;
  #         ovmf = {
  #           enable = true;
  #           packages = with pkgs; [OVMFFull.fd];
  #         };
  #         swtpm.enable = true;
  #       };
  #     };
  #     spiceUSBRedirection.enable = true;
  #   };

  system.stateVersion = lib.mkForce "22.11"; # DONT TOUCH THIS
}
