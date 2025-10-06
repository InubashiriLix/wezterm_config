return function(wezterm, config)
    local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
    local theme_bg = scheme.background

    local GLYPH_SEMI_CIRCLE_LEFT = ""
    local GLYPH_SEMI_CIRCLE_RIGHT = ""

    local colors = {
        default = { bg = "#45475a", fg = "#cdd6f4" },
        is_active = { bg = "#45475a", fg = "#f5e0dc" },
        hover = { bg = "#f5e0dc", fg = "#1e1e2e" },
    }

    local cells = {}
    local function push(bg, fg, attribute, text)
        table.insert(cells, { Background = { Color = bg } })
        table.insert(cells, { Foreground = { Color = fg } })
        table.insert(cells, { Attribute = attribute })
        table.insert(cells, { Text = text })
    end

    wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
        cells = {}

        local bg, fg
        if tab.is_active then
            bg, fg = colors.is_active.bg, colors.is_active.fg
        elseif hover then
            bg, fg = colors.hover.bg, colors.hover.fg
        else
            bg, fg = colors.default.bg, colors.default.fg
        end

        local pane_title = tab.active_pane.title
        local left_cap = "😺" .. GLYPH_SEMI_CIRCLE_LEFT
        local right_cap = GLYPH_SEMI_CIRCLE_RIGHT

        local available = max_width - wezterm.column_width(left_cap) - wezterm.column_width(right_cap)

        if available < 0 then
            available = 0
        end

        local title = pane_title
        if wezterm.column_width(title) > available then
            title = wezterm.truncate_right(title, available)
        end

        push(theme_bg, bg, { Intensity = "Bold" }, left_cap)
        push(bg, fg, { Intensity = "Bold" }, title)
        push(theme_bg, bg, { Intensity = "Bold" }, right_cap)

        return cells
    end)
end
