{ config, pkgs, ... }:

{
  imports = [
    ./users.nix
    ./packages.nix
  ];

  # Bootloader settings (if both machines use systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";   # Set your time zone.

  i18n.defaultLocale = "en_US.UTF-8";   # Select internationalisation properties.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];   # Enable Flakes and the 'nix' command

  networking.networkmanager.enable = true;   # Networking
  nixpkgs.config.allowUnfree = true;
}
