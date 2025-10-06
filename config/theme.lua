return function(wezterm, config)
    -- 选一个默认启用
    config.color_scheme = "Akai Mono (Dark)"
    config.bold_brightens_ansi_colors = true

    -- 自定义主题集合
    config.color_schemes = {
        ["Akai Mono (Dark)"] = {
            foreground = "#E6E6E6",
            background = "#0B0B0D",
            cursor_bg = "#FF3B3B",
            cursor_fg = "#0B0B0D",
            cursor_border = "#FF3B3B",
            selection_bg = "#222327",
            selection_fg = "#E6E6E6",
            -- ANSI 16 色：黑/红/绿/黄/蓝/品红/青/白
            ansi = { "#151518", "#FF3B3B", "#4E927F", "#D9BA4E", "#4FB0FF", "#E16E9A", "#4EC2C2", "#E6E6E6" },
            brights = { "#4A4A50", "#FF5A5A", "#6AA09A", "#E6CB6B", "#75C1FF", "#F18DB1", "#6CD9D9", "#FFFFFF" },
            tab_bar = {
                background = "#0B0B0D",
                active_tab = { bg_color = "#151518", fg_color = "#FFFFFF" },
                inactive_tab = { bg_color = "#0B0B0D", fg_color = "#AAAAAA" },
                new_tab = { bg_color = "#0B0B0D", fg_color = "#FF3B3B" },
            },
        },

        ["Akai Mono (Light)"] = {
            foreground = "#111113",
            background = "#F7F7F7",
            cursor_bg = "#C70039",
            cursor_fg = "#F7F7F7",
            cursor_border = "#C70039",
            selection_bg = "#EDEDED",
            selection_fg = "#111113",
            ansi = { "#1A1A1C", "#C70039", "#2E9B70", "#B3922F", "#2F86C7", "#B24D78", "#2F9B9B", "#3A3A3E" },
            brights = { "#6E6E74", "#E0003F", "#44B884", "#C9A844", "#4AA2DF", "#CF6A95", "#48BDBD", "#111113" },
            tab_bar = {
                background = "#F7F7F7",
                active_tab = { bg_color = "#FFFFFF", fg_color = "#111113" },
                inactive_tab = { bg_color = "#F2F2F2", fg_color = "#666666" },
                new_tab = { bg_color = "#F7F7F7", fg_color = "#C70039" },
            },
        },
    }
end
