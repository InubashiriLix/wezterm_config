-- 字体配置：根据平台选择合适的 Nerd Font
local wezterm = require('wezterm')
local platform = require('utils.platform')

---@class WeztermFontTbl
---@field family string
---@field weight 'Thin'|'ExtraLight'|'Light'|'Medium'|'SemiBold'

---@class FontConfig
---@field font_family_options string[] 可选字体列表
---@field wezterm_font WeztermFontTbl 默认字体配置
---@field font_size number 默认字体大小
---@field freetype_load_target 'Normal'|'Light'|'Mono'|'HorizontalLcd'
---@field freetype_render_target 'Normal'|'Light'|'Mono'|'HorizontalLcd'
local M = {}

M.font_family_options = {
    'Maple Mono NF CN',
    'Maple Mono Normal NF CN',
    'CaskaydiaCove Nerd Font',
    'JetBrainsMono Nerd Font',
    'CartographCF Nerd Font',
}

M.wezterm_font = {
    family = M.font_family_options[1],
    weight = 'Medium',
}

M.font_size = platform.is_mac and 12 or 12
M.freetype_load_target = 'Normal' ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
M.freetype_render_target = 'Normal' ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'

---@param items string[]
---@param target string
---@return number|nil
local function index_of(items, target)
    for i, v in ipairs(items) do
        if v == target then
            return i
        end
    end
    return nil
end

---@param window any
---@return string
function M:get_current_family(window)
    local overrides = window:get_config_overrides() or {}
    if overrides.font and overrides.font.family then
        return overrides.font.family
    end

    local effective = window:effective_config()
    if effective.font and effective.font.family then
        return effective.font.family
    end

    return self.wezterm_font.family
end

---@param window any
---@param family string
function M:apply_family(window, family)
    if not family then
        return
    end

    local overrides = window:get_config_overrides() or {}
    local font_size = overrides.font_size or window:effective_config().font_size or self.font_size

    overrides.font = wezterm.font({
        family = family,
        weight = self.wezterm_font.weight,
    })
    overrides.font_size = font_size
    overrides.freetype_load_target = self.freetype_load_target
    overrides.freetype_render_target = self.freetype_render_target

    window:set_config_overrides(overrides)
    window:toast_notification('WezTerm Font', family, nil, 2000)
end

---@param window any
---@param step number
function M:cycle_family(window, step)
    local current = self:get_current_family(window)
    local idx = index_of(self.font_family_options, current)

    if not idx then
        local fallback_idx = step > 0 and 1 or #self.font_family_options
        self:apply_family(window, self.font_family_options[fallback_idx])
        return
    end

    local next_idx = ((idx - 1 + step) % #self.font_family_options) + 1
    self:apply_family(window, self.font_family_options[next_idx])
end

---@param window any
function M:reset(window)
    local overrides = window:get_config_overrides() or {}
    overrides.font = nil
    overrides.font_size = nil
    overrides.freetype_load_target = nil
    overrides.freetype_render_target = nil

    if next(overrides) == nil then
        window:set_config_overrides(nil)
    else
        window:set_config_overrides(overrides)
    end

    window:toast_notification('WezTerm Font', 'Reset to default', nil, 2000)
end

function M:setup()
    wezterm.on('fonts.select-family', function(window, pane)
        local choices = {}
        for _, family in ipairs(self.font_family_options) do
            table.insert(choices, { id = family, label = family })
        end

        window:perform_action(
            wezterm.action.InputSelector({
                title = 'Select Font Family',
                choices = choices,
                fuzzy = true,
                fuzzy_description = 'Select Font: ',
                action = wezterm.action_callback(function(inner_window, _pane, id, label)
                    self:apply_family(inner_window, id or label)
                end),
            }),
            pane
        )
    end)

    wezterm.on('fonts.cycle-family-next', function(window, _pane)
        self:cycle_family(window, 1)
    end)

    wezterm.on('fonts.cycle-family-prev', function(window, _pane)
        self:cycle_family(window, -1)
    end)

    wezterm.on('fonts.reset-family', function(window, _pane)
        self:reset(window)
    end)
end

function M:load()
    return {
        font = wezterm.font(self.wezterm_font),
        font_size = self.font_size,
        freetype_load_target = self.freetype_load_target,
        freetype_render_target = self.freetype_render_target,
    }
end

return M
