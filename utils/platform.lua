local wezterm = require('wezterm')

local function is_found(str, pattern)
   return str ~= nil and string.find(str, pattern, 1, true) ~= nil
end

local function env_contains(name, needle)
   local value = os.getenv(name)
   if value == nil then
      return false
   end
   return is_found(value:lower(), needle:lower())
end

---@alias PlatformType 'windows' | 'linux' | 'mac'

---@return {os: PlatformType, is_win: boolean, is_linux: boolean, is_mac: boolean, is_wayland: boolean, is_niri: boolean}
local function platform()
   local is_win = is_found(wezterm.target_triple, 'windows')
   local is_linux = is_found(wezterm.target_triple, 'linux')
   local is_mac = is_found(wezterm.target_triple, 'apple')
   local session_type = os.getenv('XDG_SESSION_TYPE')
   local is_wayland = session_type == 'wayland' or os.getenv('WAYLAND_DISPLAY') ~= nil
   local is_niri = is_linux
      and (
         os.getenv('NIRI_SOCKET') ~= nil
         or env_contains('XDG_CURRENT_DESKTOP', 'niri')
         or env_contains('DESKTOP_SESSION', 'niri')
      )
   local os

   if is_win then
      os = 'windows'
   elseif is_linux then
      os = 'linux'
   elseif is_mac then
      os = 'mac'
   else
      error('Unknown platform')
   end

   return {
      os = os,
      is_win = is_win,
      is_linux = is_linux,
      is_mac = is_mac,
      is_wayland = is_wayland,
      is_niri = is_niri,
   }
end

local _platform = platform()

return _platform
