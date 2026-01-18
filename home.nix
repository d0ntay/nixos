{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "d0ntay";
  home.homeDirectory = "/home/d0ntay";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  ####################################
  # @neovim
  ####################################
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua          # file explorer
      telescope-nvim         # Fuzzy finder
      plenary-nvim           # required by telescope
      nvim-autopairs         # autocomlete for closing braces etc..
    ];
  };

  ####################################
  # @waybar
  ####################################
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ./.config/waybar/config);
    };
    style = builtins.readFile ./.config/waybar/style.css;
  };  
  ####################################
  # @kitty
  ####################################
  programs.kitty = {
    enable = true;
    themeFile = "gruvbox-dark";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;

      background_opacity = "0.95";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };
  ####################################
  # @zsh
  ####################################
  programs.zsh = {
    enable = true;
    initExtra= ''
      eval "$(starship init zsh)"
    '';
  };
  ####################################
  # @starship
  ####################################
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$username$hostname$directory$character";
      username = {
        show_always = true;
	format = "[$user]($style)";
	style_user = "bold white";
      };
      hostname = {
        ssh_only = false;
	format = "[@$hostname]($style)";
	style = "bold white";
      };
      directory = {
        truncation_length = 3;
      };
      character = {
        success_symbol = "[>](bold green)";
	error_symbol = "[>](bold red)";
      };
    };
  };

  ####################################
  # @git
  ####################################
    programs.git = {
      enable = true;
      userName = "d0ntay";
      userEmail = "d0ntay@d0ntay.com";
      extraConfig = {
	init.defaultBranch = "main";
      };
    };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
