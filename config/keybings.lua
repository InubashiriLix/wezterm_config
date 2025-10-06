return function(wezterm, config)
    config.keys = {
        { key = "Enter", mods = "CTRL", action = wezterm.action.ToggleFullScreen },
        { key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },
        { key = "t", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS" }) },
        { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS" }) },
        { key = "e", mods = "ALT", action = wezterm.action.ShowTabNavigator },
        { key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
        -- { key = "n", mods = "SUPER", action = wezterm.action.SpawnWindow },
        { key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "w", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
        { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
        { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
        { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
        { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
        { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
        { key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
        { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
        { key = "RightArrow", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
        { key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
    }
end
