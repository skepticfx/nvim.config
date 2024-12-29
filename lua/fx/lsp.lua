vim.opt.signcolumn = 'yes'
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(event)
		local opts = {buffer = event.buf}

		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		-- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	end,
})

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lspconfig_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup({})
local cmp_lsp = require("cmp_nvim_lsp")
local cmp = require("cmp")
local capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	cmp_lsp.default_capabilities())

require("mason").setup()


require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
	},
	handlers = {
		function(server_name) -- default handler (optional)

			require("lspconfig")[server_name].setup {
				capabilities = capabilities
			}
		end,

		["lua_ls"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "it", "describe", "before_each", "after_each" },
						}
					}
				}
			}
		end,
	}
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
		['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	},
	{
		{ name = 'buffer' },
	})
})

vim.diagnostic.config({
	-- update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
-- Copy the line + error message in the current line to clipboard
vim.keymap.set("n", "<leader>ce", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.fn.line(".") - 1 -- Current line (0-based)
	local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
	local current_line_text = vim.fn.getline(line + 1) -- Get the current line's text

	-- Collect diagnostic messages for the line
	local diagnostic_messages = {}
	for _, diagnostic in ipairs(diagnostics) do
		table.insert(diagnostic_messages, diagnostic.message)
	end

	if #diagnostic_messages > 0 then
		-- Prepare the combined text
		local combined_text = current_line_text .. "\n-- Diagnostics: " .. table.concat(diagnostic_messages, "; ")

		-- Copy the combined text to clipboard and append it as the next line
		vim.fn.setreg("+", combined_text)
		print("Copied line and diagnostics to clipboard" )
	else
		print("No diagnostics on this line")
	end
end, { desc = "Copy current line and diagnostics as the next line" })


vim.keymap.set("v", "<leader>ce", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local start_line = vim.fn.line("v") - 1 -- Start of the visual selection (0-based)
	local end_line = vim.fn.line(".") - 1 -- End of the visual selection (0-based)
	local lines = vim.fn.getline(start_line + 1, end_line + 1) -- Get selected lines

	-- Collect diagnostic messages for the selected range
	local diagnostic_messages = {}
	for lnum = start_line, end_line do
		local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
		for _, diagnostic in ipairs(diagnostics) do
			table.insert(diagnostic_messages, string.format("[%d:%d] %s", lnum + 1, diagnostic.col, diagnostic.message))
		end
	end

	if #diagnostic_messages > 0 then
		-- Prepare the combined text
		local selected_text = table.concat(lines, "\n")
		local combined_text = selected_text .. "\n-- Diagnostics: " .. table.concat(diagnostic_messages, "; ")

		-- Copy the combined text to the clipboard
		vim.fn.setreg("+", combined_text)
		print("Copied selection and diagnostics to clipboard")
	else
		print("No diagnostics in the selected range")
	end
end, { desc = "Copy selection and diagnostics" })

