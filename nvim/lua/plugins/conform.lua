return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
			markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },
		},
		formatters = {
			["markdown-toc"] = {
				condition = function(_, ctx)
					for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
						if line:find("<!%-%- toc %-%->") then
							return true
						end
					end
				end,
			},
			["markdownlint-cli2"] = {
				condition = function(_, ctx)
					local diag = vim.tbl_filter(function(d)
						return d.source == "markdownlint"
					end, vim.diagnostic.get(ctx.buf))
					return #diag > 0
				end,
			},
		},
		format_on_save = function(bufnr)
			-- Disable for certain filetypes
			local disable_filetypes = { "json" }
			if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
				return
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback", -- fallback to LSP if formatter not found
			}
		end,
	},
}
