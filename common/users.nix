{ pkgs, ... }:

{
  users.users.d0ntay = {
    isNormalUser = true;
    description = "d0ntay";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3..." ];
  };

  programs.zsh.enable = true;
}
