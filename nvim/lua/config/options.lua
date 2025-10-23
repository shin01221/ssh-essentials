vim.g.vim_markdown_frontmatter = 1
vim.opt.spell = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"

-- basic
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.concealcursor = "c" -- show conceal only in normal and command mode
vim.opt.autoread = true
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.python3_host_prog = vim.fn.expand("~/.local/venvs/nvim/bin/python")
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wrap = false -- No Wrap lines
vim.o.virtualedit = "block" -- make visual select go beyond the end of the line
vim.opt.shell = "fish"
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.scrolloff = 15
vim.opt.cmdheight = 1
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.inccommand = "split"
vim.o.list = true
vim.o.confirm = true
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})
-- enable universal clipboard
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
-- end basics
