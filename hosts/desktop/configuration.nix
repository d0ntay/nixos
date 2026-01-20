{config, pkgs, ... }:

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  imports = [
    ./hardware-configuration.nix
  ];
  
  ############################
  # greetd
  ############################
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };
  
  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
  ############################
  # Hyprlock
  ############################
    security.pam.services.hyprlock = {};

  ############################
  # CPU (INTEL)
  ############################
  hardware.cpu.intel.updateMicrocode = true;

  ############################
  # Graphics (NVIDIA)
  ############################
  hardware.graphics = {  # Replaces hardware.opengl in newer NixOS
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
  
  # Power management (recommended for desktop with powerful GPU)
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  
  # Use open-source drivers for 50-series (generally better performance)
    open = true;  # RTX 50-series has excellent open driver support
  
    nvidiaSettings = true;
  
  # Use latest production driver for RTX 5080
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  nixpkgs.config.allowUnfree = true;
  
  ############################
  # Steam
  ############################
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
      "/home/d0ntay/.steam/root/compatibilitytools.d";

        # NVIDIA-specific for Wayland/Hyprland
    WLR_NO_HARDWARE_CURSORS = "1";  # Prevents cursor issues
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };
  
  ############################
  # Services for GUI controls
  ############################
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.nm-applet.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  ############################
  # Packages
  ############################
  environment.systemPackages = with pkgs; [
    mangohud			# system monitor for gaming (fps,temps,etc)
    protonup-ng                 # linux gaming on steam sort of like wine
    nvtopPackages.full          # gpu monitor like btop
  ];
  
  ############################
  # Networking
  ############################
  networking.hostName = "nixos-d";
}
