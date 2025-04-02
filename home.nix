  { config, pkgs, ... }:

  {
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
   ];
   
   programs.fish.enable = true;
   programs.fish.shellAliases = {
   ls = "eza -al --group-directories-first --icons";
   vim = "nvim";
   };
   
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

