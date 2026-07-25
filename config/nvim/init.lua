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
vim.opt.colorcolumn = "80"
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
            { mode = { 'n', 'x' }, keys = '<Leader>' },
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },
            { mode = 'i', keys = '<C-x>' },
            { mode = { 'n', 'x' }, keys = 'g' },
            { mode = { 'n', 'x' }, keys = "'" },
            { mode = { 'n', 'x' }, keys = '`' },
            { mode = { 'n', 'x' }, keys = '"' },
            { mode = { 'i', 'c' }, keys = '<C-r>' },
            { mode = 'n', keys = '<C-w>' },
            { mode = { 'n', 'x' }, keys = 'z' },
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
      "windwp/nvim-autopairs",
      lazy = true,
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({})
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
          conditionals = { "italic" },
          loops = { "bold" },
          functions = { "bold" },
          keywords = { "bold" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
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
            Comment = { fg = colors.overlay1 },
            CursorLineNr = { fg = colors.green, style = { "bold" } },
          }
        end,
        auto_integrations = true,
        integrations = {
          aerial = false,
          alpha = false,
          artio = false,
          barbar = false,
          barbar = false,
          barbecue = {
            dim_dirname = true,
            bold_basename = true,
            dim_context = false,
            alt_background = false,
          },
          beacon = false,
          blink_cmp = {
            style = 'bordered',
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
            git_status = false
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
            enabled = true,
          },
          lsp_trouble = true,
          dadbod_ui = false,
          gitgutter = false,
          illuminate = {
            enabled = true,
            lsp = false
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
    local path_package = vim.fn.stdpath('data') .. '/site'
    local mini_path = path_package .. '/pack/deps/start/mini.nvim'
    if not vim.loop.fs_stat(mini_path) then
      vim.cmd('echo "Installing `mini.nvim`" | redraw')
      local clone_cmd = {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/nvim-mini/mini.nvim',
        mini_path
      }
      vim.fn.system(clone_cmd)
      vim.cmd('packadd mini.nvim | helptags ALL')
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
    vim.pack.add({ gh("zuqini/zpack.nvim") })
    local ok, zpack = pcall(require, "zpack")
    if ok then
      zpack.setup(specs_tbl)
    end
    return
  end
end

bootstrap_manager(profile, specs)
