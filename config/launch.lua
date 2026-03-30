-- 启动入口配置：按平台准备默认 shell 与菜单
local platform = require('utils.platform')

local options = {
    default_prog = {},
    launch_menu = {},
}

if platform.is_win then
    -- Windows 默认启用 PowerShell Core
    options.default_prog = { 'pwsh', '-NoLogo' }
    options.launch_menu = {
        { label = 'PowerShell Core', args = { 'pwsh', '-NoLogo' } },
        { label = 'PowerShell Desktop', args = { 'powershell' } },
        { label = 'Command Prompt', args = { 'cmd' } },
        -- { label = 'Nushell', args = { 'nu' } },
        {
            label = 'Msys2',
            args = {
                'cmd',
                '/c',
                'C:/msys64/msys2_shell.cmd',
                '-defterm',
                '-here',
                '-no-start',
                '-ucrt64',
            },
        },
        {
            label = 'Git Bash',
            args = {
                'cmd',
                '/c',
                'C:\\Program Files (x86)\\Git\\bin\\bash.exe',
                '--login',
                '-i',
            },
        },
        {
            label = 'Ubuntu2',
            args = { 'C:\\Windows\\System32\\wsl.exe', '--cd', '~', '-d', 'Ubuntu2' },
        },
    }
elseif platform.is_mac then
    -- macOS 中使用 Homebrew 安装的 Fish 作为默认 shell
    options.default_prog = { '/opt/homebrew/bin/fish', '-l' }
    options.launch_menu = {
        { label = 'Bash', args = { 'bash', '-l' } },
        { label = 'Fish', args = { '/opt/homebrew/bin/fish', '-l' } },
        { label = 'Nushell', args = { '/opt/homebrew/bin/nu', '-l' } },
        { label = 'Zsh', args = { 'zsh', '-l' } },
    }
elseif platform.is_linux then
    -- Linux 保持常见 shell 选项
    options.default_prog = { 'bash', '-l' }
    options.launch_menu = {
        { label = 'Bash', args = { 'bash', '-l' } },
        { label = 'Zsh', args = { 'zsh', '-l' } },
    }
end

return options
