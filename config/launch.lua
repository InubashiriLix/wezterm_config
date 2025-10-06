return function(wezterm, config)
    -- Populate the launcher so opening a new tab offers the same choices as Windows Terminal.
    local launch_menu = {}

    local function add_windows_entry(label, args, cwd)
        table.insert(launch_menu, {
            label = label,
            args = args,
            cwd = cwd,
        })
    end

    add_windows_entry("PowerShell 7", { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" })
    add_windows_entry("Windows PowerShell", { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" })
    add_windows_entry("Command Prompt", { "cmd.exe" })

    add_windows_entry("Anaconda PowerShell (0-02_MiniConda)", {
        "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
        "-ExecutionPolicy",
        "ByPass",
        "-NoExit",
        "-Command",
        "& 'D:\\0-02_MiniConda\\shell\\condabin\\conda-hook.ps1'; conda activate 'D:\\0-02_MiniConda'",
    }, "C:\\Users\\lixinrong")

    add_windows_entry("Anaconda Prompt (0-02_MiniConda)", {
        "cmd.exe",
        "/K",
        "D:\\0-02_MiniConda\\Scripts\\activate.bat D:\\0-02_MiniConda",
    }, "C:\\Users\\lixinrong")

    -- WSL distributions
    local desired_wsl_domains = {
        { name = "WSL:Ubuntu2", distribution = "Ubuntu2" },
        -- { name = "WSL:Kali-Linux", distribution = "Kali-Linux" },
        -- { name = "WSL:arch", distribution = "arch" },
    }

    config.wsl_domains = config.wsl_domains or {}

    local known_domain_names = {}
    for _, domain in ipairs(config.wsl_domains) do
        known_domain_names[domain.name] = true
    end

    for _, domain in ipairs(desired_wsl_domains) do
        if not known_domain_names[domain.name] then
            table.insert(config.wsl_domains, domain)
        end
    end

    local function add_wsl_entry(label, domain_name)
        table.insert(launch_menu, {
            label = label,
            domain = { DomainName = domain_name },
        })
    end

    -- add_wsl_entry("WSL: Ubuntu-24.04", "WSL:Ubuntu-24.04")
    add_wsl_entry("WSL: Ubuntu2", "WSL:Ubuntu2")
    -- add_wsl_entry("WSL: Kali-Linux", "WSL:Kali-Linux")
    -- add_wsl_entry("WSL: Arch", "WSL:arch")

    config.launch_menu = launch_menu
end
