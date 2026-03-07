-- 引入基础配置模块，组合其他模块的配置
local Config = require('config')

-- 初始化并配置桌面背景工具
require('background_cfg').setup()

-- 注册左侧状态栏信息
require('events.left-status').setup()
-- 注册右侧状态栏信息，设置日期时间格式
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
-- 注册标签标题展示，控制未激活标签显示样式
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'numbered_box' })
-- 注册新建标签按钮
require('events.new-tab-button').setup()
-- 注册 GUI 启动时执行的初始化逻辑
require('events.gui-startup').setup()

-- 依次组合各项子配置，最终返回完整的 WezTerm 配置
return Config
    :init()
    :append(require('config.appearance')) -- 外观相关设置
    :append(require('config.bindings')) -- 快捷键设置
    :append(require('config.domains')) -- 域与 SSH 等远程配置
    :append(require('config.fonts')) -- 字体设置
    :append(require('config.general')) -- 通用行为设置
    :append(require('config.launch'))
    :append(require('config.image')) -- enable the kitty graphics protocol
    .options -- 启动项配置并返回选项
