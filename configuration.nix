# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "storage" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes and experimental Nix CLI
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # SDDM
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  git
  neovim
  firefox
  kitty
  linuxKernel.packages.linux_6_6.rtl8188eus-aircrack
  nix-output-monitor
  usbutils
  pciutils
  rofi
  mate.caja
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
  nixpkgs-fmt
  nixfmt-rfc-style
  alejandra
  ];

  # Sudo Stuff
  security.sudo = {
    extraConfig = ''
      Defaults pwfeedback
      Defaults lecture = never
    '';
  };

  # Fish Stuff
  programs.fish.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

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
  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

    # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
