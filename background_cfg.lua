-- 背景配置模块：统一设置遮罩颜色与透明度
local backdrops = require('utils.backdrops')

local BackgroundCfg = {}

function BackgroundCfg.setup()
   backdrops
      :set_focus('#000000', 1.0) --
      :set_overlay('#000000', 0.8) -- the background overlay color and opacity
      :set_images() -- set the image
      :random()
end

return BackgroundCfg
