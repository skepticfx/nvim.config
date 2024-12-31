-- only for Windows - specifically WSL

if vim.fn.system('uname -r'):match('microsoft') then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c Get-Clipboard',
            ['*'] = 'powershell.exe -c Get-Clipboard',
        },
        cache_enabled = 0,
    }
end

