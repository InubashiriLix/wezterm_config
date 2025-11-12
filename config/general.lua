-- 通用行为配置：控制滚动、超链与提示信息
return {
   -- 行为相关设置
   automatically_reload_config = true,
   exit_behavior = 'CloseOnCleanExit', -- 当 shell 正常退出时关闭窗口
   exit_behavior_messaging = 'Verbose',
   status_update_interval = 1000,
   audible_bell = 'Disabled',

   scrollback_lines = 20000,

   hyperlink_rules = {
      -- 匹配形如 (URL) 的链接
      {
         regex = '\\((\\w+://\\S+)\\)',
         format = '$1',
         highlight = 1,
      },
      -- 匹配形如 [URL] 的链接
      {
         regex = '\\[(\\w+://\\S+)\\]',
         format = '$1',
         highlight = 1,
      },
      -- 匹配形如 {URL} 的链接
      {
         regex = '\\{(\\w+://\\S+)\\}',
         format = '$1',
         highlight = 1,
      },
      -- 匹配形如 <URL> 的链接
      {
         regex = '<(\\w+://\\S+)>',
         format = '$1',
         highlight = 1,
      },
      -- 捕获未带包裹符号的纯 URL
      {
         regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
         format = '$0',
      },
      -- 匹配邮箱地址并转成 mailto 链接
      {
         regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
         format = 'mailto:$0',
      },
   },
}
