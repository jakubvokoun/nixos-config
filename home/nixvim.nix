{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    enableMan = true;

    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    globals = {
      mapleader = " ";
    };

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

      laststatus = 2;

      fileencoding = "utf-8";

      termguicolors = true;
    };

    # Custom filetypes
    filetype = {
      extension = {
        tilt = "starlark";
      };
      filename = {
        "Tiltfile" = "starlark";
        "tiltfile" = "starlark";
      };
    };

    # Plugins
    plugins = {
      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          experimental = {
            ghost_text = false;
          };
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          formatting = {
            fields = [
              "kind"
              "abbr"
              "menu"
            ];
          };
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
            "<Tab>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };

      cmp-nvim-lsp = {
        enable = true;
      }; # lsp
      cmp-buffer = {
        enable = true;
      };
      cmp-path = {
        enable = true;
      }; # file system paths
      cmp_luasnip = {
        enable = true;
      }; # snippets
      cmp-cmdline = {
        enable = false;
      }; # autocomplete for cmdline

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
          ccls.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          gopls.enable = true;
          ansiblels = {
            enable = true;
            package = pkgs.ansible-language-server;
          };
          lua_ls.enable = true;
          pylsp = {
            enable = true;
            settings.plugins.pylint = {
              enabled = true;
              executable = "${config.home.homeDirectory}/.nix-profile/bin/pylint";
            };
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
          tinymist.enable = true;
          typst_lsp = {
            enable = true;
            package = pkgs.tinymist;
          };
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

      zen-mode.enable = true;

      nvim-tree.enable = true;

      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          preset = "classic";
        };
      };

      typst-vim.enable = true;

      typst-preview.enable = true;

      # Disalbed
      web-devicons.enable = false;
      mini.enable = false;
    };
  };
}
