{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 
  {
  home.username = "anderson";
  home.homeDirectory = "/home/anderson";

  imports = [
    ./pkgs/hyprland.nix
  ];

  # User Packages
  home.packages = with pkgs; [
    ranger
    zip
    xz
    unzip
    p7zip
    eza
    tree
    gnutar
    btop
    pavucontrol
    nwg-look
    waybar
    grim
    rofi
    slurp
    git-credential-manager
    vscode
    nix-prefetch-git
    adwaita-icon-theme
    tela-icon-theme
    adw-gtk3
    myrepo.x-cursor-pro
    mate.engrampa
    capitaine-cursors
    waypaper
    swaybg
    clipse
    wl-clipboard
    lunar-client
    fastfetch
    neofetch
    prismlauncher
    mate.caja
    nurl
    nix-init
    nh
    nix-output-monitor
    nvd
    nixd
    alejandra 
    nixfmt-rfc-style
    nixpkgs-fmt
    nix-output-monitor
    fishPlugins.grc
    grc
    lunarvim
    protonvpn-gui
    cmake
    flatpak
    stow
    tmux
    inkscape
    microsoft-edge
    zellij
    unrar
    mcpelauncher-ui-qt
    zenity
    pcsx2
    wineWowPackages.stable
    winetricks
    gtk3
    helix
  ];

  fonts.fontconfig.enable = true;

  # Fish
  programs.fish = { 
    enable = true;
    shellAliases = {
      ls = "eza -lah --group-directories-first --icons";
      vim = "nvim";
      gitcompush = "git commit -a && git push";
      nixrebuild = "nh os switch --update";
      nixupgrade = "sudo nixos-rebuild switch --upgrade";
      emacs = "emacsclient -c -a 'emacs'";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
    { name = "grc"; src = pkgs.fishPlugins.grc; }
    ];
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
  };

  programs.rofi = {
    enable = true;
  };

  lib.mkForce.programs.kitty = {
    enable = true;
    settings = {
      linux_display_server = "wayland";
      wayland_titlebar_color = "background";
      font_family = "Fira Code";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 11;
      background_opacity = 0.8;
      # window settings
      initial_window_width = "95c";
      initial_window_height = "35c";
      window_padding_width = 0;
      confirm_os_window_close = 0;
    };
  };

  # Caja
  xdg.desktopEntries.caja = {
    name = "Caja";
    genericName = "Caja";
    exec = "caja";
    type = "Application";
    icon = ./assets/cajaicon.png;
  };

  # Theming
  gtk.enable = true;
  gtk.cursorTheme.package = pkgs.myrepo.x-cursor-pro;
  gtk.cursorTheme.name = "XCursor-Pro-Dark";
  # lib.mkForce.gtk.theme.package = pkgs.adw-gtk3;
  # gtk.theme.name = "adw-gtk3";
  gtk.iconTheme.package = pkgs.tela-icon-theme;
  gtk.iconTheme.name = "Tela-black-dark";

  # Git
  programs.git = {
    enable = true;
    userName = "codeandb";
    userEmail = "andersonphang001@gmail.com";
    extraConfig.credential.helper = "manager";
    extraConfig.credential."https://github.com".username = "codeandb";
    extraConfig.credential.credentialStore = "cache";
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
