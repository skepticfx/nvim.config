-- All these runs after plugins
-- some global remaps are done in fx/lazy.lua

-- netrw
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- telescope and LSP
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<C-b>', builtin.buffers, { desc = 'Telescope find buffers' })
vim.keymap.set('n', '<C-s>', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<C-t>', builtin.lsp_references, { desc = 'References' })
vim.keymap.set('n', '<C-i>', builtin.lsp_implementations, { desc = 'Implementations' })

-- primetime
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- indent the entire file in place
vim.keymap.set('n', '<C-0>', function()
    local pos = vim.fn.getpos(".")  -- Save current cursor position
    vim.cmd("normal gg=G")                -- Indent the entire file
    vim.fn.setpos(".", pos)        -- Restore cursor position
end, { noremap = true })

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

