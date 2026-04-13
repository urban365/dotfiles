local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup("plugins")

local opts = vim.opt
opts.mouse = ""
opts.backup = false
opts.swapfile = false
opts.termguicolors = true
opts.relativenumber = true
opts.clipboard = "unnamedplus"
opts.tabstop = 4
opts.shiftwidth = 4
opts.scrolloff = 8
opts.foldmethod = "indent"
opts.foldenable = false

vim.g.cursorhold_updatetime = 100
vim.g.netrw_banner = 0

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

local keymap = vim.keymap.set
local telescope_builtin = require("telescope.builtin")
keymap("", "<Space>", "<Nop>", { silent = true })
keymap("n", "<C-s>", "<cmd>update<cr>", { silent = true })
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { silent = true })
keymap("n", "<leader>i", "<cmd>set expandtab shiftwidth=2 tabstop=2<cr>", { silent = true })
keymap("n", "<leader>f", telescope_builtin.find_files, { desc = "Find files", silent = true })
keymap("n", "<leader>g", telescope_builtin.live_grep, { desc = "Live grep", silent = true })
keymap("n", "<leader>b", telescope_builtin.buffers, { desc = "Buffers", silent = true })
keymap("n", "<leader>o", telescope_builtin.oldfiles, { desc = "Recent files", silent = true })
keymap("n", "<leader>t", telescope_builtin.help_tags, { desc = "Help tags", silent = true })
keymap("n", "<leader>/", function()
  telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Fuzzy search in current buffer", silent = true })
keymap("n", "<C-p>", telescope_builtin.git_files, { desc = "Git files", silent = true })
keymap("n", "<leader>h", "<cmd>noh<cr>", { silent = true })
keymap("n", "<leader>p", "<cmd>vertical resize +5<cr>", { silent = true })
keymap("n", "<leader>m", "<cmd>vertical resize -5<cr>", { silent = true })
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("i", "<C-j>", "<esc>:m .+1<CR>==")
keymap("i", "<C-k>", "<esc>:m .-2<CR>==")
keymap("n", "<leader>k", ":m .-2<CR>==")
keymap("n", "<leader>j", ":m .+1<CR>==")
keymap("n", "+", "<C-a>")
keymap("n", "-", "<C-x>")
keymap("n", "H", "<cmd>tabprevious<cr>", { silent = true })
keymap("n", "L", "<cmd>tabnext<cr>", { silent = true })
keymap("n", "<leader>c", "<cmd>bd<cr>", { silent = true })
keymap("n", "<leader>q", "<cmd>qa<cr>", { silent = true })
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

local function apply_macos_background()
  if vim.fn.has("mac") ~= 1 then
    return
  end

  vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  if vim.v.shell_error == 0 then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end

vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
  callback = function()
    apply_macos_background()
  end,
})

-- catppuccin
require("catppuccin").setup({
  flavour = "auto", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "macchiato",
  },
  auto_integrations = true,
  integrations = {
    nvimtree = true,
    telescope = true,
    lualine = true,
  },
})
apply_macos_background()
vim.cmd.colorscheme("catppuccin")

-- nvim-tree
require("nvim-tree").setup({
  renderer = {
    root_folder_label = false
  },
  filters = {
    custom = {"^.git$"},
    dotfiles = true
  }
})

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- nvim-autopairs
local npairs = require("nvim-autopairs")
npairs.setup({
  disable_filetype = { "TelescopePrompt", "vim" },
  check_ts = true,
  ts_config = {
    lua = { "string" }, -- It does not add a pair in the listed treesitter nodes.
    javascript = { "template_string" },
  },
})

-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "markdown_inline",
    "json",
    "yaml",
    "toml",
    "bash",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  autotag = {
    enable = true,
  }
}

-- telescope
local telescope = require("telescope")
local telescope_actions = require("telescope.actions")

telescope.setup({
  defaults = {
    path_display = { "smart" },
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
      width = 0.9,
      height = 0.85,
    },
    file_ignore_patterns = {
      "node_modules",
      ".git/",
    },
    mappings = {
      i = {
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-k>"] = telescope_actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
    },
  },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown({}),
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
