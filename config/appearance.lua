return function(wezterm, config)
    -- 尺寸 & 外观
    config.initial_cols = 120
    config.initial_rows = 28
    config.window_decorations = "RESIZE"
    config.use_fancy_tab_bar = false
    config.tab_max_width = 80
    config.hide_tab_bar_if_only_one_tab = false
    -- config.color_scheme = "Catppuccin Mocha"

    -- ✅ 极简字体：主 + 单一中文 + Emoji（减少字体回退分段渲染的开销）
    -- config.font = wezterm.font_with_fallback({
    --     "JetBrains Mono", -- 主字体（确认你机器上有这个名字）
    --     -- { family = "Sarasa Mono SC", scale = 1.05 }, -- 中文；没有就换 "Microsoft YaHei" / "Noto Sans CJK SC"
    --     -- "Segoe UI Emoji", -- Windows Emoji
    -- })
    config.font = wezterm.font("JetBrains Mono")
    config.use_cap_height_to_scale_fallback_fonts = true -- 让回退字体高度对齐，减少抖动
    config.font_size = 14

    -- 提升动画帧率，让 cursor smear 更丝滑（不想动显卡可降到 90/60）
    config.animation_fps = 120
    config.max_fps = 120

    -- 如果仍感觉不顺，把光标改为稳定块并关闭闪烁（按需打开）：
    -- config.default_cursor_style = "SteadyBlock"
    -- config.cursor_blink_rate = 0

    -- Shell
    config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }

    -- 边距 & 透明度
    config.window_padding = { top = 0 }
    config.window_background_opacity = 1.0
    config.text_background_opacity = 1.0

    -- 若 WebGPU 驱动不稳、拖影卡顿，可退回 OpenGL（按需打开）：
    -- config.front_end = "OpenGL"

    -- background img
    config.window_background_image = "C:/Users/lixinrong/.config/wezterm/share/momiji1.png"
    config.window_background_image_hsb = {
        brightness = 0.09, -- 亮度
        hue = 1.0, -- 色相
        saturation = 1.9, -- 饱和度
    }
end
