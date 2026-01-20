{ config, pkgs, ... }:

{
  imports = [
    ./users.nix
    ./packages.nix
  ];
  ############################
  # Time & Locale
  ############################
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };

  ############################
  # Boot
  ############################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ############################
  # Networking
  ############################
  networking.networkmanager.enable = true;
  
  ############################
  # ENV variables
  ############################
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    
    GTK_THEME = "Adwaita-dark";  
  };
  
  ############################
  # Fonts
  ############################
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  ############################
  # Shell
  ############################
  programs.zsh.enable = true;


  ############################
  # Settings for nix
  ############################
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  ############################
  # System version
  ############################
  system.stateVersion = "25.11";
}

