{ pkgs, ... }:

let 
  autostart = pkgs.writeShellScriptBin "autostart" ''
  #!/bin/sh
  waybar &
  waypaper --restore &
  /nix/store/$(ls -la /nix/store | grep 'mate-polkit' | grep '4096' | awk '{print $9}' | sed -n '$p')/libexec/polkit-mate-authentication-agent-1 & 
  dunst &
  hyprctl setcursor XCursor-Pro-Dark 20 &
  clipse -listen &
  '';

in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    #plugins = [
    #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
    #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.dwindle-autogroup
    #];
    # set the flake package

    settings = {
      # Environment Variables
      "$terminal" = "kitty";
      "$fileManager" = "pcmanfm";
      "$menu" = "rofi -show drun";
      #$scripts = ~/.config/hypr/scripts
      "$mainMod" = "SUPER";

      exec-once = "${autostart}/bin/autostart";

      env = [
        "XCURSOR_SIZE,20"
        "HYPRCURSOR_SIZE,20"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1 "
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 8;
          passes = true;
          new_optimizations = true;
          vibrancy = "0.1696";
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = false;
      };

      master = {
        new_status = "slave";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          natural_scroll = false;
        };
      };

      # Keybinds
      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "SUPER_SHIFT, C, killactive,"
        "SUPER_SHIFT, Q, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, SPACE, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, J, togglesplit, "
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      windowrule = [
        "float, class:(clipse)"
        "stayfocused, class:(clipse)"
      ];

      windowrulev2 = [
        "size 400 400, class:(clipse)"
        "suppressevent maximize, class:.*"# You'll probably like this
      ];



    };
  };
}