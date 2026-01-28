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
    pkgs.libnotify
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
  # @swaync
  ####################################
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "bottom";
    };
  };
  ########################################
# Neovim
####################################
programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  # Language servers & CLI tools
  extraPackages = with pkgs; [
    ripgrep
    nixd
    pyright
    gopls
  ];

  plugins = with pkgs.vimPlugins; [
    # LSP
    nvim-lspconfig

    # Completion
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    luasnip
    cmp_luasnip

    # UI / QoL
    nvim-tree-lua
    telescope-nvim
    plenary-nvim
    nvim-autopairs
    nvim-web-devicons
    gruvbox-nvim
  ];

  extraLuaConfig = ''
    --------------------------------------------------
    -- Basic settings
    --------------------------------------------------
    vim.g.mapleader = " "
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.termguicolors = true

    --------------------------------------------------
    -- Theme
    --------------------------------------------------
    vim.o.background = "dark"
    vim.cmd("colorscheme gruvbox")

    --------------------------------------------------
    -- Plugins
    --------------------------------------------------
    require("nvim-tree").setup()
    require("nvim-autopairs").setup()

    --------------------------------------------------
    -- LSP
    --------------------------------------------------
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    lspconfig.nixd.setup({
      capabilities = capabilities,
    })

    lspconfig.pyright.setup({
      capabilities = capabilities,
    })

    lspconfig.gopls.setup({
      capabilities = capabilities,
    })

    --------------------------------------------------
    -- LSP keymaps
    --------------------------------------------------
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

    --------------------------------------------------
    -- Completion (nvim-cmp)
    --------------------------------------------------
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
      },
    })

    --------------------------------------------------
    -- Telescope
    --------------------------------------------------
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
    vim.keymap.set("n", "<leader>fh", builtin.help_tags)

    --------------------------------------------------
    -- Nvim-tree
    --------------------------------------------------
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
  '';
};
################################
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
    settings = {
      user = {
        name = "d0ntay";
        email = "d0ntay@d0ntay.com";
      };
      init = {
        defaultBranch = "main";
      }; 
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
