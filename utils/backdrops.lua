local wezterm = require('wezterm')
local colors = require('colors.custom')
local platform = require('utils.platform')

-- Seeding random numbers before generating for use
-- Known issue with lua math library
-- see: https://stackoverflow.com/questions/20154991/generating-uniform-random-numbers-in-lua
math.randomseed(os.time())
math.random()
math.random()
math.random()

local GLOB_PATTERN = '*.{jpg,jpeg,png,gif,bmp,ico,tiff,pnm,dds,tga}'

---@class BackDrops
---@field current_idx number index of current image
---@field images string[] background images
---@field images_dir string directory of background images. Default is wezterm.config_dir .. '/backdrops/'
---@field focus_color string 焦点模式下的背景色
---@field focus_opacity number 焦点模式遮罩透明度
---@field overlay_color string 背景图模式叠加的遮罩颜色
---@field overlay_opacity number 背景图模式遮罩透明度
---@field focus_on boolean focus mode on or off
local BackDrops = {}
BackDrops.__index = BackDrops

--- Initialise backdrop controller
---@private
function BackDrops:init()
    local inital = {
        current_idx = 1,
        images = {},
        images_dir = wezterm.config_dir .. '/backdrops/',
        focus_color = colors.background,
        focus_opacity = 1,
        overlay_color = colors.background,
        overlay_opacity = 0.96,
        focus_on = false,
    }
    local backdrops = setmetatable(inital, self)
    return backdrops
end

---Enable frosted glass effect (Windows: Acrylic/Mica, macOS: Vibrancy)
---@param enable boolean enable or disable frosted glass effect
---@param glass_type string? type of frosted glass ('Acrylic', 'Mica', 'MicaAlt' for Windows)
---@param opacity number? window background opacity (0.0-1.0)
---@return BackDrops self for method chaining
function BackDrops:set_frosted_glass(enable, glass_type, opacity)
    self.frosted_glass_enabled = enable or false

    if enable then
        if platform.is_mac then
            -- macOS uses macos_window_background_blur
            self.macos_window_background_blur = 20
            self.window_background_opacity = opacity or 0.8
        elseif platform.is_linux then
            -- Linux doesn't have native frosted glass support
            self.window_background_opacity = opacity or 0.8
        elseif platform.is_win then
            -- Windows uses win32_system_backdrop
            self.win32_system_backdrop = glass_type or 'Acrylic'
            self.window_background_opacity = opacity or 0.8
        end
    end

    return self
end

---Override the default `images_dir`
---Default `images_dir` is `wezterm.config_dir .. '/backdrops/'`
---
--- INFO:
---  This function must be invoked before `set_images()`
---
---@param path string directory of background images
function BackDrops:set_images_dir(path)
    self.images_dir = path
    if not path:match('/$') then
        self.images_dir = path .. '/'
    end
    return self
end

---MUST BE RUN BEFORE ALL OTHER `BackDrops` functions
---Sets the `images` after instantiating `BackDrops`.
---
--- INFO:
---   During the initial load of the config, this function can only invoked in `wezterm.lua`.
---   WezTerm's fs utility `glob` (used in this function) works by running on a spawned child process.
---   This throws a coroutine error if the function is invoked in outside of `wezterm.lua` in the -
---   initial load of the Terminal config.
function BackDrops:set_images()
    self.images = wezterm.glob(self.images_dir .. GLOB_PATTERN)
    return self
end

---Override the default `focus_color`
---Default `focus_color` is `colors.background`
---@param focus_color string background color when in focus mode
---@param focus_opacity number? focus overlay opacity
function BackDrops:set_focus(focus_color, focus_opacity)
    self.focus_color = focus_color
    if focus_opacity ~= nil then
        self.focus_opacity = focus_opacity
    end
    return self
end

---Override the default overlay color/opacity
---Default `overlay_color` is `colors.background`
---@param color string overlay color for images
---@param opacity number? overlay opacity
function BackDrops:set_overlay(color, opacity)
    self.overlay_color = color
    if opacity ~= nil then
        self.overlay_opacity = opacity
    end
    return self
end

--- Modify the overlay opacity
---@param window_or_opacity number?
---@param opacity number?
---@return BackDrops self for method chaining
function BackDrops:mod_overlay_opacity(window_or_opacity, opacity)
    -- Support both signatures: (opacity) or (window, opacity)
    local window = window_or_opacity
    if type(window_or_opacity) == 'number' or window_or_opacity == nil then
        opacity = window_or_opacity
        window = nil
    end

    if type(opacity) ~= 'number' then
        wezterm.log_error('BackDrops:mod_overlay_opacity - Expected a number')
        return self
    end

    -- simple clamp between 0 and 1
    if opacity < 0 then
        opacity = 0
    elseif opacity > 1 then
        opacity = 1
    end
    self.overlay_opacity = opacity

    if window ~= nil then
        if self.focus_on then
            self:_set_opt(window, self:_create_focus_opts())
        else
            self:_set_opt(window, self:_create_opts())
        end
    end

    return self
end

---Create the `background` options with the current image
---@private
---@return table
function BackDrops:_create_opts()
    return {
        {
            source = { File = self.images[self.current_idx] },
            horizontal_align = 'Center',
        },
        {
            source = { Color = self.overlay_color },
            height = '120%',
            width = '120%',
            vertical_offset = '-10%',
            horizontal_offset = '-10%',
            opacity = self.overlay_opacity,
        },
    }
end

---Create the `background` options for focus mode
---@private
---@return table
function BackDrops:_create_focus_opts()
    return {
        {
            source = { Color = self.focus_color },
            height = '120%',
            width = '120%',
            vertical_offset = '-10%',
            horizontal_offset = '-10%',
            opacity = self.focus_opacity,
        },
    }
end

---Get frosted glass config options to be merged into WezTerm config
---@return table config options for frosted glass effect
function BackDrops:get_frosted_glass_opts()
    local opts = {}

    if self.frosted_glass_enabled then
        if self.win32_system_backdrop then
            opts.win32_system_backdrop = self.win32_system_backdrop
        end
        if self.macos_window_background_blur then
            opts.macos_window_background_blur = self.macos_window_background_blur
        end
        if self.window_background_opacity then
            opts.window_background_opacity = self.window_background_opacity
        end
    end

    return opts
end

---Set the initial options for `background`
---@param focus_on boolean? focus mode on or off
function BackDrops:initial_options(focus_on)
    focus_on = focus_on or false
    assert(type(focus_on) == 'boolean', 'BackDrops:initial_options - Expected a boolean')

    self.focus_on = focus_on
    if focus_on then
        return self:_create_focus_opts()
    end

    return self:_create_opts()
end

---Override the current window options for background
---@private
---@param window any WezTerm Window see: https://wezfurlong.org/wezterm/config/lua/window/index.html
---@param background_opts table background option
function BackDrops:_set_opt(window, background_opts)
    window:set_config_overrides({
        background = background_opts,
        enable_tab_bar = window:effective_config().enable_tab_bar,
    })
end

---Override the current window options for background with focus color
---@private
---@param window any WezTerm Window see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:_set_focus_opt(window)
    local opts = {
        background = {
            {
                source = { Color = self.focus_color },
                height = '120%',
                width = '120%',
                vertical_offset = '-10%',
                horizontal_offset = '-10%',
                opacity = self.focus_opacity,
            },
        },
        enable_tab_bar = window:effective_config().enable_tab_bar,
    }
    window:set_config_overrides(opts)
end

---Convert the `files` array to a table of `InputSelector` choices
---see: https://wezfurlong.org/wezterm/config/lua/keyassignment/InputSelector.html
function BackDrops:choices()
    local choices = {}
    for idx, file in ipairs(self.images) do
        table.insert(choices, {
            id = tostring(idx),
            label = file:match('([^/]+)$'),
        })
    end
    return choices
end

---Select a random background from the loaded `files`
---Pass in `Window` object to override the current window options
---@param window any? WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:random(window)
    self.current_idx = math.random(#self.images)

    if window ~= nil then
        self:_set_opt(window, self:_create_opts())
    end

    return self
end

---Cycle the loaded `files` and select the next background
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:cycle_forward(window)
    if self.current_idx == #self.images then
        self.current_idx = 1
    else
        self.current_idx = self.current_idx + 1
    end
    self:_set_opt(window, self:_create_opts())
end

---Cycle the loaded `files` and select the previous background
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:cycle_back(window)
    if self.current_idx == 1 then
        self.current_idx = #self.images
    else
        self.current_idx = self.current_idx - 1
    end
    self:_set_opt(window, self:_create_opts())
end

---Set a specific background from the `files` array
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
---@param idx number index of the `files` array
function BackDrops:set_img(window, idx)
    if idx > #self.images or idx < 0 then
        wezterm.log_error('Index out of range')
        return
    end

    self.current_idx = idx
    self:_set_opt(window, self:_create_opts())
end

---Toggle the focus mode
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:toggle_focus(window)
    local background_opts

    if self.focus_on then
        background_opts = self:_create_opts()
        self.focus_on = false
    else
        background_opts = self:_create_focus_opts()
        self.focus_on = true
    end

    self:_set_opt(window, background_opts)
end

return BackDrops:init()
