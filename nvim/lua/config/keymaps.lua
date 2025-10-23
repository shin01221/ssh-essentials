local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "tt", vim.cmd.Themery)
--toggle top bar buffer on or off
keymap.set("n", "<leader>bs", function()
	if vim.o.showtabline == 0 then
		vim.o.showtabline = 2
	else
		vim.o.showtabline = 0
	end
end, { desc = "Toggle bufferline visibility" })
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "Format current file" })

-- convienince
vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "NextBuffer" })
keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "PrevBuffer" })

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Select all
keymap.set("n", "aa", "gg<S-v>G")
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set("n", "vv", "0v$h")
keymap.set("i", "jj", "<esc>")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "gf", "<C-W>gf")

-- deletion don't affect buffer
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
keymap.set("n", "qq", vim.cmd.q)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
keymap.set("n", "<c-k>", "<C-w>k")
keymap.set("n", "c-j>", "<C-w>j")
keymap.set("n", "c-h>", "<C-w>h")
keymap.set("n", "<c-l>", "<C-w>l")

-- resize window
keymap.set("n", "<C-w><l>", "<C-w><")
keymap.set("n", "<C-w><h>", "<C-w>>")
keymap.set("n", "<C-w><j>", "<C-w>+")
keymap.set("n", "<C-w><k>", "<C-w>-")

-- move highlited text
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
