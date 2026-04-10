-- Lightweight and modern Neovim configuration for scripting
local vim = vim
local api = vim.api
local opt = vim.opt
local g = vim.g
local keymap = vim.keymap

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

-- Leader keys
g.mapleader = " "
g.maplocalleader = " "

-- Core Options
opt.mouse = ""
opt.backup = false
opt.swapfile = false
opt.termguicolors = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.scrolloff = 8
opt.foldenable = false
opt.splitbelow = true
opt.splitright = true
g.netrw_banner = 0

-- Disable automatic comment on new line
api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Keymaps
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  keymap.set(mode, lhs, rhs, opts)
end

-- Save and Quit
map("n", "<C-s>", "<cmd>update<cr>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>c", "<cmd>bd<cr>", { desc = "Close Buffer" })

-- Movement & Resizing
map("n", "<leader>h", "<cmd>noh<cr>", { desc = "Clear Search Highlights" })
map("n", "<leader>p", "<cmd>vertical resize +5<cr>", { desc = "Increase Width" })
map("n", "<leader>m", "<cmd>vertical resize -5<cr>", { desc = "Decrease Width" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page Down & Center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page Up & Center" })
map("n", "H", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "L", "<cmd>tabnext<cr>", { desc = "Next Tab" })

-- Move lines up and down
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })
map("n", "<leader>j", ":m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<leader>k", ":m .-2<cr>==", { desc = "Move Line Up" })

-- Formatting
map("n", "<leader>i", "<cmd>set expandtab shiftwidth=2 tabstop=2<cr>", { desc = "Indent 2 spaces" })

-- Plugins (lazy.nvim plugin setup)
require("lazy").setup({
  -- Colorscheme & Auto Dark Mode
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.opt.background = "dark"
        vim.cmd("colorscheme tokyonight-night")
        local ok, lualine = pcall(require, "lualine")
        if ok then 
          package.loaded["lualine.themes.tokyonight"] = nil
          lualine.setup({ options = { theme = "tokyonight" } })
        end
      end,
      set_light_mode = function()
        vim.opt.background = "light"
        vim.cmd("colorscheme tokyonight-day")
        local ok, lualine = pcall(require, "lualine")
        if ok then 
          package.loaded["lualine.themes.tokyonight"] = nil
          lualine.setup({ options = { theme = "tokyonight" } })
        end
      end,
    },
  },

  -- Statusline (Lualine instead of lightline for Lua)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        icons_enabled = true,
        section_separators = '',
        component_separators = '|',
      },
    },
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
    opts = {
      renderer = { root_folder_label = false },
      filters = { custom = { "^.git$" }, dotfiles = true },
    },
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    },
    opts = {
      defaults = { preview = false },
    },
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if ok then
        ts.setup({
          -- Minimal parsing for scripting/config
          ensure_installed = { "bash", "lua", "python", "json", "yaml" }, 
          highlight = { enable = true, additional_vim_regex_highlighting = false },
        })
      end
    end,
  },

  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
    opts = {
      size = 20,
      open_mapping = [[<C-t>]],
      close_on_exit = true,
      direction = "float",
      float_opts = { border = "curved" },
    },
  },
})
