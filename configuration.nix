# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  #nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anderson = {
    isNormalUser = true;
    description = "anderson phang";
    extraGroups = ["networkmanager" "plugdev" "wheel" "video" "audio" "storage" "openrazer"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # SDDM
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;

  # Env variables
  environment.sessionVariables = {
    FLAKE = "/home/anderson/nixos-config";
  };

  # Nix Settings
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "01hcls239dpa8f0y1lhhvbqaln94kndii95id2s8lydpdbrd0xcw";
    }))
  ];

  # Apps and Packages
  environment.systemPackages = with pkgs; [
    git
    neovim
    firefox
    kitty
    linuxKernel.packages.linux_6_6.rtl8188eus-aircrack
    usbutils
    pciutils
    mate.mate-polkit
    gvfs
    unzip
    pcmanfm
    ntfs3g
    dunst
    udisks
    linuxHeaders
    gnumake
    fuse
    polkit
    fish
    cachix
    emacs
    ripgrep
    coreutils
    fd
    clang
    cmake
    libtool
    polychromatic
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    zulu23
    darktable
  ];

  fonts.packages = with pkgs;
    [
      font-awesome
      fira
      fira-code
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Sudo Stuff
  security.sudo = {
    extraConfig = ''
      Defaults pwfeedback
      Defaults lecture = never
    '';
  };

  programs.nix-ld.enable = true;

  # Stylix
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };

  services.flatpak.enable = true;

  # Fish Stuff
  programs.fish.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Gaming
  hardware.openrazer.enable = true;
  
  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.fabric = {
      # skibiddyserver = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_5;
      serverProperties = {
        gamemode = "survival";
        simulation-distance = 8;
        online-mode = false;
        autoStart = false; # Start with systemctl start minecraft-server-fabric
        enableReload = true;
      };
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-Api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/hBmLTbVB/fabric-api-0.121.0%2B1.21.5.jar";
              sha256 = "sha256-GbKETZqAN5vfXJF0yNgwTiogDAI434S3Rj9rZw6B53E=";
            };
            FixSkins = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/MwSVYzQz/skinrestorer-2.3.1%2B1.21.5-fabric.jar";
              sha256 = "sha256-fTtwSW/mbrq9n5fQGZSUkRgmjSU6sE++klN1dd1tF5o=";
            };
            FerriteCore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
              sha256 = "sha256-K5C/AMKlgIw8U5cSpVaRGR+HFtW/pu76ujXpxMWijuo=";
            };
            Lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/VWYoZjBF/lithium-fabric-0.16.2%2Bmc1.21.5.jar";
              sha256 = "sha256-XqvnQxASa4M0l3JJxi5Ej6TMHUWgodOmMhwbzWuMYGg=";
            };
            C2ME = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/VSNURh3q/versions/eL3rprSq/c2me-fabric-mc1.21.5-0.3.2.0.0.jar";
              sha256 = "sha256-E4vkzzZnI381lfpth2vdfnL71EdeNw6TTMQGn14JBq0=";
            };
            #Noisium = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/9NHdQfkN/noisium-fabric-2.5.0%2Bmc1.21.4.jar";
            #  sha256 = "sha256-JmSbfF3IDaC1BifR8WaKFCpam6nHlBWQzVryDR6Wvto=";
            #};
            #VMP = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/EKg6v67t/vmp-fabric-mc1.21.5-0.2.0%2Bbeta.7.198-all.jar";
            #  sha256 = "sha256-ODTIaW3NiROyf6ve0oTLUG2jLS0OChNvQmZuAsZjTdk=";
            #};
            #ModernFix = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/nmDcB62a/versions/ZGxQddYr/modernfix-fabric-5.20.3%2Bmc1.21.4.jar";
            #  sha256 = "sha256-zrQ15ShzUtw1Xty1yxxO/n8xYofpaATSF9ewEeqE/d4=";
            #};
            Krypton = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/neW85eWt/krypton-0.2.9.jar";
              sha256 = "sha256-uGYia+H2DPawZQxBuxk77PMKfsN8GEUZo3F1zZ3MY6o=";
            };
            #LMD = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/vE2FN5qn/versions/M9egl08c/letmedespawn-1.21.5-fabric-1.5.1.jar";
            #  sha256 = "sha256-s/1FyEKge3+C/8Wh3/0hfBZ2gx/5+V0S0Ddqi1xPSLg=";
            #};
            #Chunky = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/fALzjamp/versions/mhLtMoLk/Chunky-Fabric-1.4.36.jar";
            #  sha256 = "sha256-vLttrvBeviawvhMk2ZcjN5KecT4Qy+os4FEqMPYB77U=";
            #};
            #Legacy4J = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/gHvKJofA/versions/YzoJpwj1/Legacy4J-1.21.5-1.8.1-fabric.jar";
            #  sha256 = "sha256-d4RJzLneAxEnH3ojyZCzkw6MfjHGOhQ0GHW1TAjQSSQ=";
            #};
          }
        );
      };
      jvmOpts = "-Xms1G -Xmx2G -XX:+UseG1GC ";
      #};
    };
  };
  # File Management
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;

  # System Maintenance
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  #  Enable OpenGL
  hardware.graphics.enable = true;

  # NVIDIA Stuff
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Limit the number of generations to keep
  boot.loader.grub.configurationLimit = 10;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  boot.blacklistedKernelModules = [
    "rtl8xxxu"
    "r8188eu"
  ];

  boot.kernelModules = ["8188eu" "rtl8188eu" "8188eus" "rtl8188eus" "8188"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
