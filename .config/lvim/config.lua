--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
	enabled = true,
	pattern = "*.lua",
	timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
-- lvim.builtin.treesitter.auto_install = false

vim.cmd([[
set number relativenumber
set hidden
noremap d w
noremap w r
noremap e k
noremap f u
noremap j y
noremap k n
noremap l m
noremap n j
noremap o l
noremap r e
noremap t f
noremap u i
noremap y h
noremap v b
noremap c v
noremap h d
noremap b t
noremap D W
noremap W R
noremap E K
noremap F U
noremap J Y
noremap K N
noremap L M
noremap N J
noremap O P
noremap R E
noremap T F
noremap U I
noremap Y H
noremap V B
noremap C V
noremap H D
noremap B T
noremap ~ $
noremap ^ ~
noremap ` ^
nnoremap <C-y> <C-w>h
nnoremap <C-n> <C-w>j
nnoremap <C-e> <C-w>k
nnoremap <C-o> <C-w>l
nmap <TAB> :bn<Enter>
nmap <S-TAB> :bp<Enter>
]])

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
lvim.lsp.automatic_configuration.skipped_servers = {
	"angularls",
	"ansiblels",
	"antlersls",
	"csharp_ls",
	"clangd",
	"cmake-language-server",
	"cssmodules_ls",
	"denols",
	"docker_compose_language_service",
	"ember",
	"emmet_ls",
	"eslint",
	"glint",
	"golangci_lint_ls",
	"gradle_ls",
	"graphql",
	"jedi_language_server",
	"ltex",
	"neocmake",
	"phpactor",
	"psalm",
	"pylsp",
	"pyre",
	"quick_lint_js",
	"reason_ls",
	"rnix-lsp",
	"rome",
	"ruby_ls",
	"ruff_lsp",
	"solang",
	"solc",
	"sorbet",
	"sourcery",
	"spectral",
	"sqlls",
	"sqls",
	"stylelint_lsp",
	"svlangserver",
	"tflint",
	"unocss",
	"verible",
	"vtsls",
	"vuels",
	"pylyzer",
}
require("lspconfig").clangd.setup({})
lvim.lsp.automatic_servers_installation = false
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ exe = "black", filetypes = { "python" } },
	{ exe = "isort", filetypes = { "python" } },
	{ exe = "shfmt", filetypes = { "sh" } },
	{ exe = "stylua", filetypes = { "lua" } },
	{ exe = "prettier", filetypes = { "css" } },
	{ exe = "alejandra", filetypes = { "nix" } },
})
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{
		command = "shellcheck",
		args = { "--severity", "warning" },
		filetypes = { "sh" },
	},
})

lvim.lsp.servers = {
	name = "rnix",
	cmd = { "rnix-lsp" },
}
-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  {
 "ellisonleao/glow.nvim",
  ft = {"markdown"},
  config = function () require("glow").setup() end
  

  -- build = "yay -S glow"
},
}
-- lvim.builtin.telescope.on_config_done = function(telescope)
--   pcall(telescope.load_extension, "glow")
--   -- pcall(telescope.load_extension, "neoclip")
--   -- any other extensions loading
-- end

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,

