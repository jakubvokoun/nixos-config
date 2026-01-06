{ pkgs, lib, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-25.11";
  });
in {
  imports = [ nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    enableMan = true;

    viAlias = true;
    vimAlias = true;

    # Settings
    colorschemes.catppuccin.enable = true;
    colorschemes.catppuccin.settings = { flavour = "mocha"; };

    globals = { mapleader = " "; };

    extraPlugins = [ pkgs.vimPlugins.vim-caddyfile ];

    opts = {
      number = true;

      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      autoindent = true;

      swapfile = false;
      undofile = true;

      modeline = true; # Tags such as 'vim:ft=sh'
      modelines = 100; # Sets the type of modelines

      incsearch = true;
      ignorecase = true;
      smartcase = true;

      cursorline = true;

      laststatus = 3;

      fileencoding = "utf-8";

      termguicolors = true;
    };

    # Plugins
    plugins = {
      lualine.enable = true;

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          experimental = { ghost_text = false; };
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          formatting = { fields = [ "kind" "abbr" "menu" ]; };
          sources = [
            { name = "git"; }
            { name = "nvim_lsp"; }
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];
          mapping = {
            "<Down>" = "cmp.mapping.select_next_item()";
            "<Up>" = "cmp.mapping.select_prev_item()";
            "<Tab>" =
              "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            #"<C-Tab>" =
            #  "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            #"<C-j>" = "cmp.mapping.select_next_item()";
            #"<C-k>" = "cmp.mapping.select_prev_item()";
            #"<C-e>" = "cmp.mapping.abort()";
            #"<C-b>" = "cmp.mapping.scroll_docs(-4)";
            #"<C-f>" = "cmp.mapping.scroll_docs(4)";
            #"<C-Space>" = "cmp.mapping.complete()";
            #"<C-CR>" = "cmp.mapping.confirm({ select = true })";
            #"<S-CR>" =
            #  "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };

      cmp-nvim-lsp = { enable = true; }; # lsp
      cmp-buffer = { enable = true; };
      cmp-path = { enable = true; }; # file system paths
      cmp_luasnip = { enable = true; }; # snippets
      cmp-cmdline = { enable = false; }; # autocomplete for cmdline

      #cmp = {
      #   autoEnableSources = true;
      #settings.sources =
      #[ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];
      #};

      #cmp-nvim-lsp.enable = true;

      #cmp-buffer.enable = true;

      #cmp-path.enable = true;

      nix.enable = true;

      helm.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
        };
      };

      lsp-format.enable = true;

      lsp-lines.enable = true;

      lsp = {
        enable = true;
        inlayHints = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };

        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          gopls.enable = true;
          ansiblels = {
            enable = true;
            package = null;
          };
          lua_ls.enable = true;
          pylsp = {
            enable = true;
            settings.plugins.pylint.enabled = true;
          };
          terraformls.enable = true;
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
            installRustfmt = true;
          };
          just.enable = true;
          diagnosticls.enable = true;
        };
      };

      treesitter = {
        enable = true;

        nixvimInjections = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      treesitter-refactor = {
        enable = true;
        settings = {
          highlight_definitions = {
            enable = true;
            # Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = false;
          };
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          # Find files using Telescope command-line sugar.
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>b" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fd" = "diagnostics";

          # FZF like bindings
          "<C-p>" = "git_files";
          "<leader>p" = "oldfiles";
          "<C-f>" = "live_grep";
        };

        settings.defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];
          set_env.COLORTERM = "truecolor";
        };
      };

      web-devicons.enable = true;

      render-markdown.enable = true;

      zen-mode.enable = true;

      nvim-tree.enable = true;

      tiny-inline-diagnostic = {
        enable = true;
        settings = { preset = "classic"; };
      };

      claude-code = {
        enable = true;
        settings = {
          window = {
            hide_numbers = false;
            hide_signcolumn = false;
            position = "vertical";
            split_ratio = 0.5;
          };
        };
      };
    };
  };
}
