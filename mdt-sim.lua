local aura_env = aura_env
if not IsAddOnLoaded("MythicDungeonTools") then
    LoadAddOn("MythicDungeonTools")
end

if MDTSimcExportSoloButton or aura_env.frame or not MDT then
    return
end

local copy_scroll = CreateFrame('ScrollFrame', nil, UIParent, 'UIPanelScrollFrameTemplate')
copy_scroll:SetFrameStrata("TOOLTIP")
copy_scroll:SetPoint("CENTER")
copy_scroll:SetSize(800, 400)
copy_scroll:EnableMouse(true)

local bg = copy_scroll:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 1)

local copy_edit = CreateFrame('EditBox', nil, copy_scroll)
aura_env.frame = copy_edit

copy_edit:SetSize(800, 400)
copy_edit:SetMultiLine(true)
copy_edit:SetMaxLetters(99999)
copy_edit:EnableMouse(true)
copy_edit:SetFontObject(ChatFontNormal)
copy_edit:SetScript('OnEscapePressed', function()
        copy_scroll:Hide()
end)
copy_scroll:SetScrollChild(copy_edit)
copy_scroll:Hide()

local dungeon_timers = {
    [29] = 2580, -- DoS
    [30] = 1920, -- HoA
    [31] = 1800, -- MoTS
    [32] = 2280, -- PF
    [33] = 2460, -- SD
    [34] = 2340, -- SoA
    [35] = 2160, -- NW
    [36] = 2220, -- ToP
}

local export = function(mult)
    local mult = tonumber(mult)
    if not mult then
        print("percent must be number")
        return
    else
        if mult < 0 or mult > 100 then
            print("percent must be in the 0 to 100 range")
        end
    end
    
    local mdt = MDT
    local preset = MDT:GetCurrentPreset()
    local difficulty = preset.difficulty
    local frame = MDT.main_frame.sidePanel
    local db = MDT:GetDB()
    local dungeon = MDT:GetDungeonName(preset.value.currentDungeonIdx)
    local time_limit = dungeon_timers[preset.value.currentDungeonIdx]
    
    local events = {}
    
    local pull = 1
    for i = 1, #frame.newPullButtons do
        local raid_event = "raid_events+=/pull,pull="..string.format("%02d", pull)..",bloodlust=0,delay=000,enemies="
        
        local pull_button = frame.newPullButtons[i]
        if pull_button:IsShown() then
            
            local e = 0
            local first_manastorm = true
            for p = 1, #pull_button.enemyPortraits do
                local enemy_portrait = pull_button.enemyPortraits[p]
                if enemy_portrait:IsShown() then
                    local enemy = enemy_portrait.enemyData
                    
                    -- skip Volatile Memory
                    if enemy.npcId ~= 170147 then
                        
                        local boss
                        local data = MDT.dungeonEnemies[db.currentDungeonIdx]
                        for _, enemy_data in ipairs(data) do
                            if enemy_data.id == enemy.npcId then
                                boss = enemy_data.isBoss or false
                            end
                        end
                        
                        local health = MDT:CalculateEnemyHealth(boss, enemy.baseHealth, difficulty, enemy.ignoreFortified)
                        
                        if boss or not enemy.ignoreFortified then
                            -- mdt doesn't account for the s2 health buff yet
                            health = health * 1.39
                        end

                        health = health * (mult / 100)
                        
                        -- Mueh'zala
                        if (enemy.npcId == 166608) then
                            health = health * 0.1
                        end
                        
                        -- General Kaal
                        if (enemy.npcId == 162099) then
                            health = health * 0.2
                        end
                        
                        -- Manastorms, separate into 2 pulls so they're not simmed together as a 2 target fight
                        if (enemy.npcId == 164556 or enemy.npcId == 164555) then
                            health = health * 0.9
                            
                            local fixed_name = string.gsub(enemy.name, " ", "_")
                            if first_manastorm then
                                raid_event = raid_event.."\""..fixed_name.."\":"..floor(health)
                                first_manastorm = false
                                events[pull] = raid_event
                                pull = pull + 1
                            else
                                raid_event = "raid_events+=/pull,pull="..string.format("%02d", pull)..",bloodlust=0,delay=000,enemies=".."\""..fixed_name.."\":"..floor(health)
                            end
                        else
                            for c = 1, enemy.quantity do
                                local unit = boss and "" or "_"..c
                                if e > 0 then
                                    raid_event = raid_event.."|"
                                end
                                e = e + 1
                                
                                local fixed_name = string.gsub(enemy.name, "\"", "`")
                                fixed_name = string.gsub(fixed_name, "%:", "")
                                fixed_name = string.gsub(fixed_name, " ", "_")
                                
                                raid_event = raid_event.."\""..fixed_name..unit.."\":"..floor(health)
                            end
                        end
                    end
                end
            end
            events[pull] = raid_event
            pull = pull + 1
        end
    end
    copy_scroll:Show()
    
    local text = ""
    
    text = text.."fight_style=DungeonRoute\n"
    text = text.."override.bloodlust=0\n"
    text = text.."override.arcane_intellect=0\n"
    text = text.."override.power_word_fortitude=0\n"
    text = text.."override.battle_shout=0\n"
    text = text.."override.mystic_touch=0\n"
    text = text.."override.chaos_brand=0\n"
    text = text.."override.bleeding=0\n"
    
    text = text.."single_actor_batch=1\n"
    text = text.."max_time="..time_limit.."\n"
    text = text.."enemy=\""..dungeon.." "..difficulty.."\"\n"
    text = text.."enemy_health=1\n"
    text = text.."raid_events=/invulnerable,cooldown="..(time_limit * 2)..",duration="..(time_limit * 2)..",retarget=1\n"
    text = text..table.concat(events, "\n", 1, #events)
    copy_edit:SetText(text)
end

local export_button
hooksecurefunc(MDT, "ShowInterface", function(self)

    if not export_button then
        local edit = CreateFrame('EditBox', nil, MDTSidePanel, "InputBoxTemplate")
        edit:SetMaxLetters(3)
        edit:EnableMouse(true)
        edit:SetFontObject(ChatFontNormal)
        edit:SetSize(60, 20)
         -- based on logs assume about 27% of the dmg done in the dungeon should be one dps player's contribution
        edit:SetText("27")
        edit:SetAutoFocus(false)

        local label = edit:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
        label:SetText("mob health %:")
        label:SetPoint("RIGHT", edit, "LEFT", -5, 0)

        export_button = CreateFrame("Button", "MDTSimcExportSoloButton", MDTSidePanel, "UIPanelButtonTemplate")
        export_button:SetSize(120, 20)
        export_button:SetText("Simc Export")
        export_button:SetPoint("BOTTOMRIGHT", MDTSidePanel, "TOPRIGHT")
        export_button:SetScript("OnClick", function() export(edit:GetText()) end)
        export_button.edit = edit

        edit:SetPoint("BOTTOMRIGHT", export_button, "BOTTOMLEFT")
    end
end)
