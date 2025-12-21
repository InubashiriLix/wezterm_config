-- 背景配置模块：统一设置遮罩颜色与透明度
local backdrops = require('utils.backdrops')

local BackgroundCfg = {}

function BackgroundCfg.setup()
    return backdrops
        :set_focus('#000000', 1.0) -- 设置焦点模式下的背景色和透明度
        :set_overlay('#000000', 0.1) -- 设置背景图模式叠加的遮罩颜色和透明度
        :set_images() -- 设置背景图片
        :random() -- 随机选择一张背景图
end

return BackgroundCfg
