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
  # Hyprland
  ############################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
 
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
  # Printing
  ############################
  services.printing.enable = true;
  
  ############################
  # Packages
  ############################
  environment.systemPackages = with pkgs; [
    vim           		# backup text editor
    git
    wget          
    neofetch      		# fetching tool
    discord
    rofi          		# menu
    gimp			# FOSS picture editing
    feh				# picture viewer
    hyprpaper     		# wallpaper for hyprland
    btop          		# task manager thingy
    bibata-cursors              # cursor theme
    mangohud			# system monitor for gaming (fps,temps,etc)
    protonup-ng                 # linux gaming on steam sort of like wine
    xfce.thunar                 # file manager
    grim                        # screenshot
    slurp			# selected section screenshot
    hyprlock			# lock screen app for hyprland
    hypridle			# idle thing for hyprland
    networkmanagerapplet        # for network and wifi
    blueman                     # for bluetooth
    pavucontrol                 # for sound and volume
    playerctl                   # media player service
    nvtopPackages.full          # gpu monitor like btop
    libnotify			# notification daemon
    swaynotificationcenter	# notifications
    wlr-randr
    librewolf			# FOSS web browser
  ];
  
  ############################
  # User
  ############################
  users.users.d0ntay = {
    isNormalUser = true;
    description = "Dante";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  
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
  networking.hostName = "nixos";
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  ############################
  # System version
  ############################
  system.stateVersion = "25.11";
}
