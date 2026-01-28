{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common                 
  ];

  networking.hostName = "nixos-l";

  powerManagement.enable = true;   # power management
  services.libinput.enable = true; # touchpad support

  system.stateVersion = "25.11"; 

  environment.systemPackages =  [
    pkgs.brightnessctl
    pkgs.wireplumber
  ];
}
