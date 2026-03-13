-- 外观相关配置：GPU 适配器、背景与配色方案
local gpu_adapters = require('utils.gpu-adapter')
local backdrops = require('utils.backdrops')
local colors = require('colors.custom')

-- TODO: feat: dynamic change display driver and fps

-- Base appearance configuration
local appearance = {
    max_fps = 120,
    animation_fps = 120,
    front_end = 'WebGpu', ---@type 'WebGpu' | 'OpenGL' | 'Software'
    -- webgpu_backend = 'Dx12', ---@type 'Vulkan' | 'Dx12' | 'Gl'
    webgpu_power_preference = 'HighPerformance',
    webgpu_preferred_adapter = gpu_adapters:pick_best(),
    -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
    -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
    underline_thickness = '1.5pt',

    -- 光标动画相关参数
    cursor_blink_ease_in = 'EaseOut',
    cursor_blink_ease_out = 'EaseOut',
    default_cursor_style = 'BlinkingBlock',
    cursor_blink_rate = 650,

    -- 颜色主题配置
    colors = colors,

    -- 背景图：传入 true 可在启动时启用专注模式（关闭背景图）
    background = backdrops:initial_options(false), -- 默认叠加半透明黑色遮罩

    -- 滚动条设置
    enable_scroll_bar = true,

    -- 标签栏外观
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = false,
    tab_max_width = 25,
    show_tab_index_in_tab_bar = false,
    switch_to_last_active_tab_when_closing_tab = true,

    -- 命令面板样式
    command_palette_fg_color = '#b4befe',
    command_palette_bg_color = '#11111b',
    command_palette_font_size = 12,
    command_palette_rows = 25,

    -- 窗口边距与关闭行为
    window_padding = {
        left = 0,
        right = 0,
        top = 10,
        bottom = 0.0,
    },
    adjust_window_size_when_changing_font_size = false,
    window_close_confirmation = 'NeverPrompt',
    window_frame = {
        active_titlebar_bg = '#090909',
        -- font = fonts.font,
        -- font_size = fonts.font_size,
    },
    -- inactive_pane_hsb = {
    --    saturation = 0.9,
    --    brightness = 0.65,
    -- },
    inactive_pane_hsb = {
        saturation = 1,
        brightness = 1,
    },

    -- 视觉响铃效果
    visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 250,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 250,
        target = 'CursorColor',
    },
}

-- Merge frosted glass options from backdrops if enabled
local frosted_opts = backdrops:get_frosted_glass_opts()
for k, v in pairs(frosted_opts) do
    appearance[k] = v
end

return appearance
