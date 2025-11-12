-- Config 模块用于统一聚合所有子配置
local wezterm = require('wezterm')

---@class Config
---@field options table
local Config = {}
Config.__index = Config

---Initialize Config
---@return Config
function Config:init()
   -- 创建一个带有空 options 表的配置实例
   local config = setmetatable({ options = {} }, self)
   return config
end

---Append to `Config.options`
---@param new_options table new options to append
---@return Config
function Config:append(new_options)
   -- 遍历传入的配置键值并逐一合并
   for k, v in pairs(new_options) do
      if self.options[k] ~= nil then
         wezterm.log_warn(
            'Duplicate config option detected: ',
            { old = self.options[k], new = new_options[k] }
         )
         -- 避免覆盖已有键，保留原值同时记录日志
         goto continue
      end
      self.options[k] = v
      ::continue::
   end
   return self
end

return Config
