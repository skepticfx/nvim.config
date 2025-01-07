require('gitsigns').setup{
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', '<leader>h]', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '<leader>h[', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>gp', gitsigns.preview_hunk)
        map('n', '<leader>gb', function() gitsigns.blame_line{full=true} end)
        map('n', '<leader>gb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>gd', gitsigns.diffthis)

    end
}
-- fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

