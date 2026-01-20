{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    vim           		# backup text editor
    kitty
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
    #mangohud			# fps stats etc
    #protonup-ng                 # linux gaming on steam sort of like wine
    xfce.thunar                 # file manager
    grim                        # screenshot
    slurp			# selected section screenshot
    hyprlock			# lock screen app for hyprland
    hypridle			# idle thing for hyprland
    networkmanagerapplet        # for network and wifi
    blueman                     # for bluetooth
    pavucontrol                 # for sound and volume
    playerctl                   # media player service
    #nvtopPackages.full          # gpu monitor like btop
    libnotify			# notification daemon
    swaynotificationcenter	# notifications
    wlr-randr
    librewolf			# FOSS web browser
  ];
  
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
}
