{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    shadow = true;
    shadowOffsets = [(-40) (-20)];
    shadowOpacity = 0.55;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "_PICOM_SHADOW@:32c = 0"
      "window_type = 'combo'"
      "window_type = 'desktop'"
      "window_type = 'dnd'"
      "window_type = 'dock'"
      "window_type = 'menu'"
      "window_type = 'popup_menu'"
      "window_type = 'splash'"
      "window_type = 'toolbar'"
      "window_type = 'utility'"
      "class_g = 'Conky'"
      "class_g = 'slop'"
    ];

    fade = true;
    fadeDelta = 10;
    fadeSteps = [0.03 0.03];
    fadeExclude = [];

    activeOpacity = 1.0;
    inactiveOpacity = 1.0;
    menuOpacity = 1.0;
    opacityRules = [
      "70:class_g = 'splash'"
      "100:class_i = 'tray'"
      "90:class_g = 'XTerm'"
      "90:class_g = 'Alacritty'"
      "90:class_g = 'kitty'"
      "90:class_g = 'Code'"
    ];

    wintypes = {
      tooltip = {
        fade = true;
        shadow = true;
        focus = true;
        full-shadow = true;
      };
      dock = {shadow = false;};
      dnd = {shadow = false;};
      popup_menu = {opacity = 1;};
      dropdown_menu = {opacity = 1;};
      desktop = {full-shadow = false;};
      normal = {full-shadow = false;};
    };

    settings = {
      shadow-radius = 40;
      shadow-color = "#000000";
      shadow-ignore-shaped = false;

      frame-opacity = 1.0;
      inactive-opacity-override = false;
      focus-exclude = [
        "class_g = 'Peek'"
      ];

      corner-radius = 15;
      rounded-corners-exclude = [
        "_PICOM_SHADOW@:32c = 0"
        "class_g = 'awesome'"
        "class_i = 'tray'"
      ];

      experimental-backends = true;

      opacity-rule = [
        "90:class_g = 'XTerm'"
        "90:class_g = 'Alacritty'"
        "90:class_g = 'kitty'"
        "100:class_i = 'tray'"
        "100:class_g = 'Code'"
      ];

      blur = {
        method = "dual_kawase";
        kernel = "11x11gaussian";
        deviation = 1.0;
        strength = 10;
        background = true;
        background-frame = true;
        background-fixed = true;
      };

      blur-background-exclude = [
        "_GTK_FRAME_EXTENTS@:c"
        "window_type = 'combo'"
        "window_type = 'desktop'"
        "window_type = 'dnd'"
        "window_type = 'menu'"
        "window_type = 'toolbar'"
        "window_type = 'tooltip'"
        "window_type = 'utility'"
        "window_type = 'unknown'"
        "class_g = 'firefox' && window_type != 'normal'"
        "class_g = 'slop'"
      ];

      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
      glx-no-stencil = true;
      use-damage = true;
      transparent-clipping = false;
      log-level = "warn";
    };
  };
}
