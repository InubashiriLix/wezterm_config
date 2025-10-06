return function(wezterm, config)
    local modes = {
        { emoji = "", context = "Resite your baseline" },
        { emoji = "", context = "Cells." },
        { emoji = "", context = "institution" },
        { emoji = "", context = "Interlink." },
        { emoji = "", context = "Within cells interlinked." },
        -- { emoji = "", context = "You'll regret for everything you have done" },
        { emoji = "", context = "And blood-black nothingness began to spin." },
        { emoji = "", context = "Last Scene" },
        { emoji = "", context = "Absentia" },
        { emoji = "", context = "Spinning out of orbit." },
        { emoji = "", context = "Cicatrix" },
        { emoji = "", context = "Apostate" },
        { emoji = "", context = "Those Responsible" },
        { emoji = "", context = "Repentance" },
        { emoji = "", context = "Apocalypse" },
        { emoji = "", context = "091821a" },
        { emoji = "", context = "Duvet" },
        { emoji = "", context = "Zerfall" },
        { emoji = "", context = "DOW pt.2" },
        { emoji = "", context = "Ascension" },
        { emoji = "", context = "Genesis 22:10" },
        { emoji = "", context = "River of Respair" },
        { emoji = "", context = "Carrion (Corpse)" },
    }

    local current_mode_index = 1

    --- update the window
    ---@param window window
    ---@param cycle_mode string "cycle" or "random"
    local function update_status(window, cycle_mode)
        -- 这里也是状态栏的时间的展示
        local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
        local hour = tonumber(wezterm.strftime("%H"))
        local minute = tonumber(wezterm.strftime("%M"))

        local time_emoji
        if hour >= 6 and hour < 9 then
            -- 早晨（6:00 - 9:00）
            if hour == 6 and minute < 30 then
                time_emoji = "🌅" -- 日出前
            elseif hour == 9 and minute == 0 then
                time_emoji = "🌞" -- 太阳高挂
            else
                time_emoji = "🌅" -- 日出或白天早期
            end
        elseif hour >= 9 and hour < 12 then
            -- 上午（9:00 - 12:00）
            time_emoji = "🌞" -- 太阳（白天）
        elseif hour >= 12 and hour < 15 then
            -- 中午（12:00 - 15:00）
            if hour == 12 and minute < 30 then
                time_emoji = "🌞" -- 中午时分
            else
                time_emoji = "🌞" -- 太阳（白天）
            end
        elseif hour >= 15 and hour < 18 then
            -- 下午（15:00 - 18:00）
            if hour == 15 and minute < 30 then
                time_emoji = "🌇" -- 下午初期
            else
                time_emoji = "🌇" -- 傍晚或日落
            end
        else
            -- 晚上（18:00 - 6:00）
            if hour >= 18 and hour < 21 then
                time_emoji = "🌙" -- 黄昏
            elseif hour >= 21 and hour < 24 then
                time_emoji = "🌙" -- 晚上（夜晚）
            else
                time_emoji = "🌙" -- 深夜
            end
        end

        local current_mode = modes[current_mode_index]

        window:set_right_status(wezterm.format({
            -- 这里调整右边状态栏的样式
            { Attribute = { Italic = true } },
            { Attribute = { Underline = "Single" } },
            { Text = string.format("%s %s | %s %s  ", time_emoji, date, current_mode.emoji, current_mode.context) },
        }))

        if cycle_mode == "cycle" then
            current_mode_index = (current_mode_index % #modes) + 1
        elseif cycle_mode == "random" then
            current_mode_index = math.random(1, #modes)
        end
    end

    wezterm.on("update-right-status", function(window, pane)
        update_status(window, false)
    end)

    local function schedule_update(window)
        -- 这里可以调整时间
        wezterm.time.call_after(60.0, function()
            update_status(window, "random") -- use the random mode mode
            schedule_update(window)
        end)
    end

    wezterm.on("window-config-reloaded", function(window, pane)
        schedule_update(window)
    end)
end
