-- 域配置：根据平台准备 SSH、Unix 与 WSL 域
local platform = require('utils.platform')

local options = {
   -- 参考：https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {},

   -- 参考：https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- 参考：https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {},
}

if platform.is_win then
   -- Windows 下预置用于连接到 WSL 的 SSH 域
   options.ssh_domains = {
      {
         name = 'ssh:wsl',
         remote_address = 'localhost',
         multiplexing = 'None',
         default_prog = { 'fish', '-l' },
         assume_shell = 'Posix',
      },
   }

   -- Windows 下直接注册多个 WSL 发行版
   options.wsl_domains = {
      {
         name = 'wsl:ubuntu-fish',
         distribution = 'Ubuntu',
         username = 'kevin',
         default_cwd = '/home/kevin',
         default_prog = { 'fish', '-l' },
      },
      {
         name = 'wsl:ubuntu-bash',
         distribution = 'Ubuntu',
         username = 'kevin',
         default_cwd = '/home/kevin',
         default_prog = { 'bash', '-l' },
      },
   }
end

return options
