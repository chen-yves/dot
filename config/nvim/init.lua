--- References ---
-- https://github.com/astronvim/astronvim
-- https://github.com/lazyvim/lazyvim
-- https://github.com/nvchad/nvchad
-- https://github.com/nvim-lua/kickstart.nvim
-- https://github.com/nvim-mini/mini.nvim
-- https://github.com/nvim-mini/MiniMax
-- https://github.com/ayamir/nvimdots

--- Options ---
vim.opt.autowrite = true
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.history = 2000
vim.opt.virtualedit = "block"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.textwidth = 80
vim.opt.wrap = false
vim.cmd.colorscheme("habamax")

--- Keybindings ---
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set({ "i", "c" }, "jk", "<Esc>", { desc = "Back to normal mode" })
vim.keymap.set({ "n" }, "j", "gj", { desc = "J" })
vim.keymap.set({ "n" }, "k", "gk", { desc = "K" })
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k", { desc = "Go to up window" })
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Go to right window" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Go to line head" })
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Go to line head" })

--- Auto Commend ---
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("my_highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "Search", timeout = 1200 })
  end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("my_restore_last_location", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my_close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dap-float",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end)
end,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("my_auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

--- Packages ---
local profile = os.getenv("NVIM_PROFILE") or "mini"
if profile == "self" and not (vim.version().minor >= 12 or vim.version().major > 0) then
  vim.notify("Neovim version is lower than 0.12.0, switching 'mini' distribution.", vim.log.levels.WARN)
  profile = "mini"
end
vim.g.profile = profile

local specs = {}
if profile == "lazy" then
  specs = {
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "tokyonight-night",
      },
    },
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    { import = "lazyvim.plugins.extras.editor.illuminate" },
    { import = "lazyvim.plugins.extras.editor.navic" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    {
      "folke/snacks.nvim",
      opts = {
        scroll = {
          enabled = false,
        },
      },
    },
  }
end
if profile == "astro" then
  specs = {
    {
      "AstroNvim/AstroNvim",
      version = "^6",
      import = "astronvim.plugins",
    },
    { "AstroNvim/astrocommunity" },
    { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
    { import = "astrocommunity.bars-and-lines.vim-illuminate" },
    { import = "astrocommunity.comment.ts-comments-nvim" },
    { import = "astrocommunity.diagnostics.trouble-nvim" },
    { import = "astrocommunity.editing-support.nvim-treesitter-context" },
    { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
    { import = "astrocommunity.editing-support.todo-comments-nvim" },
    { import = "astrocommunity.indent.snacks-indent-hlchunk" },
    { import = "astrocommunity.pack.lua" },
  }
end
if profile == "nvchad" then
  specs = {
    {
      "NvChad/NvChad",
      lazy = false,
      branch = "v2.5",
      config = function()
        require("nvchad.options")
        require("nvchad.mappings")
        require("nvchad.autocmds")
        vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
        if (vim.uv or vim.loop).fs_stat(vim.g.base46_cache .. "defaults") then
          dofile(vim.g.base46_cache .. "defaults")
          dofile(vim.g.base46_cache .. "statusline")
        end
      end,
    },
    { import = "nvchad.plugins" },
  }
end
if profile == "mini" then
  specs = {
    {
      "echasnovski/mini.nvim",
      lazy = false,
      config = function()
        require("mini.basics").setup()
        require("mini.statusline").setup()
        require("mini.tabline").setup()
        require("mini.starter").setup()
        require("mini.files").setup()
        require("mini.pairs").setup()
        require("mini.bracketed").setup()
        require("mini.cmdline").setup()
        require("mini.icons").setup()
        require("mini.cursorword").setup()
        require("mini.indentscope").setup()
        require("mini.pick").setup()
        vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Find Buffers" })
        vim.keymap.set("n", "<leader>fw", "<Cmd>Pick grep_live<CR>", { desc = "Find Words" })
        require("mini.clue").setup({
          triggers = {
            { mode = { "n", "x" }, keys = "<Leader>" },
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },
            { mode = "i", keys = "<C-x>" },
            { mode = { "n", "x" }, keys = "g" },
            { mode = { "n", "x" }, keys = "'" },
            { mode = { "n", "x" }, keys = "`" },
            { mode = { "n", "x" }, keys = '"' },
            { mode = { "i", "c" }, keys = "<C-r>" },
            { mode = "n", keys = "<C-w>" },
            { mode = { "n", "x" }, keys = "z" },
          },
          clues = {
            require("mini.clue").gen_clues.square_brackets(),
            require("mini.clue").gen_clues.builtin_completion(),
            require("mini.clue").gen_clues.g(),
            require("mini.clue").gen_clues.marks(),
            require("mini.clue").gen_clues.registers(),
            require("mini.clue").gen_clues.windows(),
            require("mini.clue").gen_clues.z(),
          },
        })
        vim.cmd.colorscheme("miniwinter")
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = true,
      config = function()
        local ok, ts = pcall(require, "nvim-treesitter.configs")
        if ok then
          ts.setup({
            ensure_installed = {
              "bash",
              "c",
              "cpp",
              "lua",
              "markdown",
              "markdown_inline",
              "python",
              "vimdoc",
            },
            highlight = { enable = true },
          })
        end
      end,
    },
  }
end
if profile == "self" then
  specs = {
    {
      "sairyy/zshow.nvim",
      config = function()
        require("zshow").setup({
          width = 0.92,
          height = 0.88,
        })
      end,
    },
    {
      "akinsho/bufferline.nvim",
      lazy = true,
      event = "BufReadPost",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("bufferline").setup({})
      end,
    },
    {
      "Bekaboo/dropbar.nvim",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("dropbar").setup({})
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      lazy = true,
      event = "BufReadPost",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("lualine").setup({})
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("ibl").setup({
          enabled = true,
          debounce = 200,
          indent = {
            char = "│",
            tab_char = "│",
            smart_indent_cap = true,
            priority = 1,
          },
          whitespace = { remove_blankline_trail = true },
          scope = {
            enabled = true,
            char = "┃",
            show_start = false,
            show_end = false,
            injected_languages = true,
            priority = 1000,
          },
        })
      end,
    },
    {
      "rcarriga/nvim-notify",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("notify").setup({
          stages = "fade",
          render = "default",
          fps = 20,
          timeout = 2000,
          minimum_width = 50,
          background_colour = "NotifyBackground",
          on_open = function(win)
            vim.api.nvim_set_option_value("winblend", 0, { scope = "local", win = win })
            vim.api.nvim_win_set_config(win, { zindex = 90 })
          end,
          level = "INFO",
        })
        vim.notify = require("notify")
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("gitsigns").setup({
          signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
          },
          auto_attach = true,
          signcolumn = true,
          sign_priority = 6,
          update_debounce = 100,
          word_diff = false,
          current_line_blame = true,
          diff_opts = { internal = true },
          watch_gitdir = { follow_files = true },
          current_line_blame_opts = { delay = 1000, virt_text = true, virtual_text_pos = "eol" },
        })
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      keys = {
        { "<leader>xx", function() vim.cmd("Trouble diagnostics toggle") end, mode = { "n" }, desc = "Diagnostics" }
      },
      config = function()
        require("trouble").setup({})
      end,
    },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>fd", function() vim.cmd("TodoFzfLua") end, mode = { "n" }, desc = "Find todo" }
      },
      config = function()
        require("todo-comments").setup({})
      end,
    },
    {
      "folke/paint.nvim",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("paint").setup({
          highlights = {
            {
              filter = { filetype = "lua" },
              pattern = "%s*%-%-%-%s*(@%w+)",
              hl = "Constant",
            },
            {
              filter = { filetype = "python" },
              pattern = "%s*([_%w]+:)",
              hl = "Constant",
            },
          },
        })
      end,
    },
    {
      "folke/which-key.nvim",
      lazy = true,
      event = "BufReadPost",
      keys = {
        { "<leader>?", function() require("which-key").show({ global = false }) end, mode = { "n", "v" }, desc = "Buffer Local Keymap" }
      },
      config = function()
        require("which-key").setup({
          preset = "helix",
        })
      end,
    },
    {
      "windwp/nvim-autopairs",
      lazy = true,
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    },
    {
      "HiPhish/rainbow-delimiters.nvim",
      lazy = true,
      event = "InsertEnter",
      config = function()
        require('rainbow-delimiters.setup').setup({
          strategy = {
            [''] = 'rainbow-delimiters.strategy.global',
            vim = 'rainbow-delimiters.strategy.local',
          },
          query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
          },
          highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
          },
        })
        require("rainbow-delimiters").enable(0)
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = true,
      event = "BufReadPost",
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-context" },
      },
      config = function()
        local ok, ts = pcall(require, "nvim-treesitter.configs")
        if ok then
          ts.setup({
            ensure_installed = {
              "bash",
              "c",
              "cpp",
              "lua",
              "markdown",
              "markdown_inline",
              "python",
              "vimdoc",
            },
            highlight = { enable = true },
          })
        end
        require('treesitter-context').setup({
          enable = true,
          multiwindow = false,
          max_lines = 0,
          min_window_height = 0,
          line_numbers = true,
          multiline_threshold = 20,
          trim_scope = 'outer',
          mode = 'cursor',
          separator = nil,
          zindex = 20,
          on_attach = nil,
        })
      end,
    },
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<leader><leader>", function() vim.cmd("FzfLua commands") end, mode = { "n" }, desc = "Find commands" },
        { "<leader>ff", function() vim.cmd("FzfLua files") end, mode = { "n" }, desc = "Find files" },
        { "<leader>fb", function() vim.cmd("FzfLua buffers") end, mode = { "n" }, desc = "Find buffers" },
        { "<leader>fr", function() vim.cmd("FzfLua oldfiles") end, mode = { "n" }, desc = "Find recent files" },
        { "<leader>fs", function() vim.cmd("FzfLua blines") end, mode = { "n" }, desc = "Find buffer words" },
        { "<leader>fS", function() vim.cmd("FzfLua lines") end, mode = { "n" }, desc = "Find all buffer words" },
        { "<leader>fw", function() vim.cmd("FzfLua live_grep") end, mode = { "n" }, desc = "Find words" },
        { "<leader>fc", function() vim.cmd("FzfLua colorschemes") end, mode = { "n" }, desc = "Find themes" },
      },
      config = function()
        require("fzf-lua").setup({
          winopts = {
            height = 0.92,
            width = 0.88,
            border = "rounded",
          },
        })
      end,
    },
    {
      "j-hui/fidget.nvim",
      lazy = true,
      event = "LspAttach",
      config = function()
        require("fidget").setup({})
      end,
    },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "LspAttach",
      config = function()
        require("tiny-inline-diagnostic").setup({})
        vim.diagnostic.config({ virtual_text = false })
      end,
    },
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup({
          ui = {
            width = 0.92,
            height = 0.88,
            border = "rounded",
          },
        })
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local custom_server_configs = {
          ["lua_ls"] = {
            settings = {
              Lua = {},
            },
          },
        }
        mason_lspconfig.setup({
          ensure_installed = {
            "lua_ls",
          },
          automatic_installation = true,
          handlers = {
            function(server_name)
              local config = {
                capabilities = capabilities,
                single_file_support = true,
              }
              if custom_server_configs[server_name] then
                config = vim.tbl_deep_extend("force", config, custom_server_configs[server_name])
              end
              vim.lsp.config(server_name, config)
              vim.lsp.enable(server_name)
            end,
          },
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function() end,
    },
    {
      "hrsh7th/nvim-cmp",
      lazy = false,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "neovim/nvim-lspconfig",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
        "rafamadriz/friendly-snippets",
      },
      config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
        cmp.setup({
          window = {
            completion = {
              border = "rounded",
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            },
            documentation = {
              border = "rounded",
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            },
          },
          sorting = {
            priority_weight = 2,
          },
          formatting = {
            fields = { "icon", "abbr", "kind", "menu" },
            format = lspkind.cmp_format({
              maxwidth = {
                menu = 50,
                abbr = 50,
              },
              ellipsis_char = '...',
              show_labelDetails = true,
              before = function (entry, vim_item)
                return vim_item
              end
            })
          },
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          matching = {
            disallow_partial_fuzzy_matching = false,
          },
          performance = {
            async_budget = 1,
            max_view_entries = 120,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-g>"] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true })
          }),
          sources = {
            { name = "lazydev", group_index = 0 },
            { name = "nvim_lsp", max_item_count = 350 },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer" },
          },
          experimental = {
            ghost_text = {
              hl_group = "Whitespace",
            },
          },
        })
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          }),
        })
      end,
    },
  }
end
local common_specs = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    enabled = profile == "self",
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        float = {
          transparent = false,
          solid = false,
        },
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "bold" },
          loops = { "bold" },
          functions = { "bold" },
          keywords = { "italic" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = { "bold", "italic" },
          properties = {},
          types = {},
          operators = { "bold" },
          miscs = {},
        },
        lsp_styles = {
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        color_overrides = {
          all = {},
          latte = {},
          frappe = {},
          macchiato = {},
          mocha = {
            base = "#11111b",
            crust = "#11111b",
          },
        },
        highlight_overrides = {},
        custom_highlights = function(colors)
          return {
            NormalFloat = { fg = colors.text, bg = colors.mantle },
            FloatBorder = {
              fg = colors.blue,
              bg = colors.mantle,
            },
            Comment = { fg = colors.overlay1 },
            CursorLineNr = { fg = colors.green, style = { "bold" } },
            Pmenu = { fg = colors.overlay2, bg = colors.base },
            PmenuBorder = { fg = colors.surface1, bg = colors.base },
            PmenuSel = { bg = colors.green, fg = colors.base },
            CmpItemAbbr = { fg = colors.overlay2 },
            CmpItemAbbrMatch = { fg = colors.blue, style = { "bold" } },
            CmpDoc = { link = "NormalFloat" },
            CmpDocBorder = {
              fg = colors.surface1,
              bg = colors.mantle,
            },
            ["@property"] = { fg = colors.text },
            ["@keyword.return"] = { fg = colors.red, style = { "bold", "italic" } },
          }
        end,
        auto_integrations = true,
        integrations = {
          aerial = false,
          alpha = false,
          artio = false,
          barbar = false,
          barbecue = {
            dim_dirname = true,
            bold_basename = true,
            dim_context = false,
            alt_background = false,
          },
          beacon = false,
          blink_cmp = {
            style = "bordered",
          },
          blink_indent = false,
          blink_pairs = false,
          buffon = false,
          coc_nvim = false,
          colorful_winsep = {
            enabled = false,
            color = "red",
          },
          dashboard = false,
          diffview = false,
          dropbar = {
            enabled = false,
            color_mode = false,
          },
          fern = false,
          fidget = false,
          flash = false,
          fzf = false,
          gitgraph = false,
          gitsigns = true,
          grug_far = false,
          harpoon = false,
          headlines = false,
          hop = false,
          indent_blankline = {
            enabled = true,
            scope_color = "lavender",
            colored_indent_levels = true,
          },
          leap = false,
          lightspeed = false,
          lir = {
            enabled = false,
            git_status = false,
          },
          lsp_saga = false,
          markview = false,
          mason = true,
          mini = {
            enabled = false,
            indentscope_color = "lavender",
          },
          neotree = false,
          neogit = false,
          neotest = false,
          noice = false,
          notifier = false,
          cmp = true,
          copilot_vim = false,
          dap = true,
          dap_ui = true,
          navic = {
            enabled = true,
            custom_bg = "NONE",
          },
          notify = true,
          nvim_surround = false,
          nvimtree = true,
          treesitter_context = true,
          ts_rainbow2 = false,
          ts_rainbow = false,
          ufo = false,
          window_picker = false,
          octo = false,
          overseer = false,
          pounce = false,
          rainbow_delimiters = true,
          render_markdown = false,
          snacks = {
            enabled = false,
            indent_scope_color = "lavender",
          },
          symbols_outline = true,
          telekasten = false,
          telescope = {
            enabled = false,
          },
          lsp_trouble = true,
          dadbod_ui = false,
          gitgutter = false,
          illuminate = {
            enabled = true,
            lsp = false,
          },
          sandwich = false,
          signify = false,
          vim_sneak = false,
          vimwiki = false,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    enabled = profile == "self",
    config = function()
      require("onedark").setup({
        style = "warmer",
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        cmp_itemkind_reverse = false,
        toggle_style_key = nil,
        toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'},
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
        },
        lualine = {
          transparent = false,
        },
        colors = {},
        highlights = {},
        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      })
      -- require("onedark").load()
    end
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    enabled = profile == "self",
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    enabled = profile == "self",
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true,
        contrast = "",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      -- vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = profile == "self",
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "dragon",
          light = "lotus"
        },
      })
      -- vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    enabled = profile == "self",
    config = function()
      require('nightfox').setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          colorblind = {
            enable = false,
            simulate_only = false,
            severity = {
              protan = 0,
              deutan = 0,
              tritan = 0,
            },
          },
          styles = {
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE",
            functions = "bold",
            keywords = "bold",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "italic,bold",
            variables = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = {},
        },
        palettes = {},
        specs = {},
        groups = {},
      })
      -- vim.cmd.colorscheme("nordfox")
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    enabled = profile == "self",
    config = function()
      require('nordic').setup({
        on_palette = function(palette) end,
        after_palette = function(palette) end,
        on_highlight = function(highlights, palette) end,
        bold_keywords = false,
        italic_comments = true,
        transparent = {
          bg = false,
          float = false,
        },
        bright_border = true,
        reduced_blue = true,
        swap_backgrounds = false,
        cursorline = {
          bold = false,
          bold_number = true,
          theme = 'dark',
          blend = 0.85,
        },
        visual = {
          bold = true,
          bold_number = true,
          theme = 'dark',
          blend = 0.85,
        },
        noice = {
          style = 'classic',
        },
        telescope = {
          style = 'flat',
        },
        leap = {
          dim_backdrop = false,
        },
        ts_context = {
          dark_background = true,
        }
      })
      -- require('nordic').load()
    end
  },
}
for _, spec in ipairs(common_specs) do
  local is_enabled = true
  if type(spec.enabled) == "boolean" then
    is_enabled = spec.enabled
  elseif type(spec.enabled) == "function" then
    is_enabled = spec.enabled()
  end
  if is_enabled then
    table.insert(specs, spec)
  end
end

local function bootstrap_manager(name, specs_tbl)
  -- LazyVim, AstroNvim, or NvChad
  if ({ lazy = true, astro = true, nvchad = true })[name] then
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
      })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "failed to clone lazy.nvim:\n", "errormsg" },
          { out, "warningmsg" },
        }, true, {})
        return
      end
    end
    vim.opt.rtp:prepend(lazypath)
    require("lazy").setup({
      spec = specs_tbl,
      ui = {
        size = {
          width = 0.92,
          height = 0.88,
        },
        border = "rounded",
        title = " === Lazy Panel === ",
      },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "tar",
            "tarplugin",
            "zip",
            "zipplugin",
            "netrw",
            "netrwplugin",
            "netrwsettings",
            "netrwfilehandlers",
            "matchit",
            "matchparen",
            "tohtml",
            "tutor",
            "spellfile",
            "rplugin",
          },
        },
      },
    })
    return
  end

  -- mini
  if ({ mini = true })[name] then
    local path_package = vim.fn.stdpath("data") .. "/site"
    local mini_path = path_package .. "/pack/deps/start/mini.nvim"
    if not vim.loop.fs_stat(mini_path) then
      vim.cmd('echo "Installing `mini.nvim`" | redraw')
      local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/nvim-mini/mini.nvim",
        mini_path,
      }
      vim.fn.system(clone_cmd)
      vim.cmd("packadd mini.nvim | helptags ALL")
      vim.cmd('echo "Installed `mini.nvim`" | redraw')
    end
    local mini = require("mini.deps")
    mini.setup({ path = { package = mini_path } })
    for _, spec in ipairs(specs_tbl) do
      local repo = type(spec) == "table" and spec[1] or spec
      local is_lazy = type(spec) == "table" and spec.lazy
      local runner = is_lazy and mini.later or mini.now
      runner(function()
        mini.add(repo)
        if type(spec) == "table" and type(spec.config) == "function" then
          pcall(spec.config)
        end
      end)
    end
    return
  end

  -- 自定義配置
  if name == "self" then
    local gh = function(repo)
      if type(repo) == "string" and not repo:find("^https://") then
        return "https://github.com/" .. repo
      end
      return repo
    end
    -- 用`zpack.nvim`提供類似lazy的管理介面
    vim.pack.add({ gh("zuqini/zpack.nvim") })
    local ok, zpack = pcall(require, "zpack")
    if ok then
      zpack.setup(specs_tbl)
    end
    return
  end
end

bootstrap_manager(profile, specs)
