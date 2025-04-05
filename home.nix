{
  config,
  pkgs,
  ...
}: {
  home.username = "anderson";
  home.homeDirectory = "/home/anderson";

  # User Packages
  home.packages = with pkgs; [
    screenfetch
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
    nerdfonts
    waybar
    grim
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
  ];

  programs.fish.enable = true;
  programs.fish.shellAliases = {
    ls = "eza -al --group-directories-first --icons";
    vim = "nvim";
    gitcompush = "git commit -a && git push";
    nixrebuild = "nh os switch --update";
    nixupdate = "sudo nixos-rebuild switch --upgrade";
  };

  # Theming
  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.myrepo.x-cursor-pro;
  gtk.cursorTheme.name = "XCursor-Pro-Dark";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

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
