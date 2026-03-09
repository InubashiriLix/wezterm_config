-- 键盘与鼠标快捷键配置集中于此
local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}
-- 统一封装跨平台的组合键前缀

if platform.is_mac then
    mod.SUPER = 'SUPER'
    mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
    mod.SUPER = 'ALT' -- 避免与 Windows 徽标键快捷键冲突
    mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
local keys = {
    -- 常用功能 --
    { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
    { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
    {
        key = 'F3',
        mods = 'NONE',
        action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
    },

    -- select font family
    { key = 'F12', mods = 'NONE', action = act.EmitEvent('fonts.select-family') },
    -- { key = 'F5', mods = 'NONE', action = act.EmitEvent('fonts.cycle-family-next') },
    -- { key = 'F5', mods = 'SHIFT', action = act.EmitEvent('fonts.cycle-family-prev') },
    -- { key = 'F6', mods = 'NONE', action = act.EmitEvent('fonts.reset-family') },

    -- Full Screen toggle
    { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
    {key = 'Enter', mods="CTRL", action = act.ToggleFullScreen},

    -- search
    { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },

    -- website link open
    {
        key = 'u',
        mods = mod.SUPER_REV,
        action = wezterm.action.QuickSelectArgs({
            patterns = {
                '\\((https?://\\S+)\\)',
                '\\[(https?://\\S+)\\]',
                '\\{(https?://\\S+)\\}',
                '<(https?://\\S+)>',
                '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
            },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.log_info('opening: ' .. url)
                wezterm.open_with(url)
            end),
        }),
    },

    -- 光标移动 --
    { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\u{1b}OH' },
    { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\u{1b}OF' },
    { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\u{15}' },

    -- 复制粘贴 --
    { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
    { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

    -- 标签页 --
    -- 标签页：创建与关闭
    { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
    -- Open Ubuntu2 WSL distro in a new tab
    { key = 'i',          mods = mod.SUPER_REV, action = act.SpawnCommandInNewTab({ args = { 'C:\\Windows\\System32\\wsl.exe', '--cd', '~', '-d', 'Ubuntu2' } }) },
    -- WARNING: the alt + ctrl + t has been bind to start wezterm on my windows computer
    { key = 'r',          mods = mod.SUPER, action = act.ShowLauncher  },

    { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

    -- 窗口操作 --
    -- 窗口：新建窗口
    { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },

    -- 窗口：缩放窗口
    {
        key = '-',
        mods = mod.SUPER,
        action = wezterm.action_callback(function(window, _pane)
            local dimensions = window:get_dimensions()
            if dimensions.is_full_screen then
                return
            end
            local new_width = dimensions.pixel_width - 50
            local new_height = dimensions.pixel_height - 50
            window:set_inner_size(new_width, new_height)
        end)
    },
    {
        key = '=',
        mods = mod.SUPER,
        action = wezterm.action_callback(function(window, _pane)
            local dimensions = window:get_dimensions()
            if dimensions.is_full_screen then
                return
            end
            local new_width = dimensions.pixel_width + 50
            local new_height = dimensions.pixel_height + 50
            window:set_inner_size(new_width, new_height)
        end)
    },
    {
        key = 'Enter',
        mods = mod.SUPER_REV,
        action = wezterm.action_callback(function(window, _pane)
            window:maximize()
        end)
    },

    -- increaes and decrease font size
    {key = '+', mods='CTRL|SHIFT', action = act.IncreaseFontSize},
    {key = '-', mods=mod.SUPER_REV, action = act.DecreaseFontSize},

    -- 标签页：导航
    { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
    { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
    -- { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
    -- { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },
    { key = 'h',          mods = mod.SUPER, action = act.ActivateTabRelative(-1) },
    { key = 'l',          mods = mod.SUPER, action = act.ActivateTabRelative(1) },

    -- 标签页标题 --
    { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
    { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

    -- 标签栏显隐 --
    { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

    -- debug display --
    { key = 'y', mods = mod.SUPER,    action = act.ShowDebugOverlay },

    -- increase / decrase backdrop overlay opacity
    -- stylua: ignore start
    { key = 'PageDown', mods = mod.SUPER,    
        action = wezterm.action_callback(function(window, _pane)
            backdrops:mod_overlay_opacity(window, backdrops.overlay_opacity + 0.08)
            window.toast_notification("Background Opacity: " .. backdrops.overlay_opacity, "", nil, 1000)
        end)
    },

    { key = 'PageUp', mods = mod.SUPER,    
        action = wezterm.action_callback(function(window, _pane)
            backdrops:mod_overlay_opacity(window,backdrops.overlay_opacity - 0.08)
            window.toast_notification("Background Opacity: " .. backdrops.overlay_opacity, "", nil, 1000)
        end)
    },


    { key = 'PageDown', mods = mod.SUPER_REV,    
        action = wezterm.action_callback(function(window, _pane)
            backdrops:mod_overlay_opacity(window, backdrops.overlay_opacity + 0.15)
            window.toast_notification("Background Opacity: " .. backdrops.overlay_opacity, "", nil, 1000)
        end)
    },

    { key = 'PageUp', mods = mod.SUPER_REV,    
        action = wezterm.action_callback(function(window, _pane)
            backdrops:mod_overlay_opacity(window,backdrops.overlay_opacity - 0.15)
            window.toast_notification("Background Opacity: " .. backdrops.overlay_opacity, "", nil, 1000)
        end)
    },
    -- stylua: ignore end

    -- 背景控制 --
    {
        key = [[/]],
        mods = mod.SUPER,
        action = wezterm.action_callback(function(window, _pane)
            backdrops:random(window)
        end),
    },
    {
        key = [[,]],
        mods = mod.SUPER,
        action = wezterm.action_callback(function(window, _pane)
            backdrops:cycle_back(window)
        end),
    },
    {
        key = [[.]],
        mods = mod.SUPER,
        action = wezterm.action_callback(function(window, _pane)
            backdrops:cycle_forward(window)
        end),
    },
    {
        key = [[/]],
        mods = mod.SUPER_REV,
        action = act.InputSelector({
            title = 'InputSelector: Select Background',
            choices = backdrops:choices(),
            fuzzy = true,
            fuzzy_description = 'Select Background: ',
            action = wezterm.action_callback(function(window, _pane, idx)
                if not idx then
                    return
                end
                ---@diagnostic disable-next-line: param-type-mismatch
                backdrops:set_img(window, tonumber(idx))
            end),
        }),
    },

    -- the focus mode
    {
       key = 'b',
       mods = mod.SUPER,
       action = wezterm.action_callback(function(window, _pane)
          backdrops:toggle_focus(window)
       end)
    },

    -- 面板 --
    -- 面板：分割
    {
        key = [[\]],
        mods = mod.SUPER,
        action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
    },
    {
        key = [[\]],
        mods = mod.SUPER_REV,
        action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
    },

    -- 面板：缩放与关闭
    { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
    { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },
    { key = 'q',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },

    -- 面板：导航
    { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
    { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
    { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
    { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
    {
        key = 'p',
        mods = mod.SUPER_REV,
        action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
    },

    -- 面板：滚动
    { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
    { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
    { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
    { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },

    -- 键表 --
    -- 调整字体大小
    {
        key = 'f',
        mods = 'LEADER',
        action = act.ActivateKeyTable({
            name = 'resize_font',
            one_shot = false,
            timemout_milliseconds = 1000,
        }),
    },
    -- 调整面板大小
    {
        key = 'p',
        mods = 'LEADER',
        action = act.ActivateKeyTable({
            name = 'resize_pane',
            one_shot = false,
            timemout_milliseconds = 1000,
        }),
    },


}

-- stylua: ignore
local key_tables = {
    resize_font = {
        { key = 'k',      action = act.IncreaseFontSize },
        { key = 'j',      action = act.DecreaseFontSize },
        { key = 'r',      action = act.ResetFontSize },
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'q',      action = 'PopKeyTable' },
    },
    resize_pane = {
        { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
        { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
        { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
        { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'q',      action = 'PopKeyTable' },
    },
}

local mouse_bindings = {
    -- Ctrl+单击可打开鼠标所在链接
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
}

return {
    disable_default_key_bindings = true,
    -- 若需要也可禁用默认鼠标绑定
    -- disable_default_mouse_bindings = true,
    leader = { key = 'Space', mods = mod.SUPER_REV },
    keys = keys,
    key_tables = key_tables,
    mouse_bindings = mouse_bindings,
}
