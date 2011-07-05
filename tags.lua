local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = tk.colors
local cfg = tk.cfg
local L = cfg.locales
local vars = tk.vars
local api = tk.api
local tags = oUF.Tags
local events = oUF.TagEvents

local format = string.format

api.addTag('tk:druidmana', function(unit)    
    return api.formatValue(UnitPower('player', SPELL_POWER_MANA), 1e5)
end, 'UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER')

api.addTag('tk:experience', function(unit)
    local threshold, min, max = 0.01
    if (unit == 'pet') then
        min, max = GetPetExerience()
    else
        min, max = UnitXP(unit), UnitXPMax(unit)
    end
    
    if ((max - min) <= (threshold * max)) then
        return api.formatValue(max - min)
    else
        return math.floor(min / max * 100 + 0.5)..'%'
    end
end, 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UNIT_PET_EXPERIENCE UPDATE_EXHAUSTION')

api.cloneTag('tk:name', 'name')

api.addTag('tk:flags', function(unit)
    local flag
    local afk, name, realm = UnitIsAFK(unit), UnitName(unit) 
    if (afk) then 
        local init = not realm and (vars.AFKTimers[name] or GetTime())
                
        if (init) then
            vars.AFKTimers[name] = init
            flag = '<AFK ('..api.formatAFKDuration(GetTime() - init)..')>'
        else
            flag = '<AFK>'
        end
    elseif (UnitIsDND(unit)) then
        flag = '<DND>'
    end
    
    if (not afk and not realm and vars.AFKTimers[name]) then
        vars.AFKTimers[name] = nil
    end
    
    return flag
end, 'PLAYER_FLAGS_CHANGED')

api.addTag('tk:classification', function(unit)
    return L.classifications[UnitClassification(unit)]
end, 'UNIT_CLASSIFICATION_CHANGED')

api.addTag('tk:classbase', function(unit)
    if (UnitIsPlayer(unit) or (UnitIsEnemy('player', unit) and not api.UnitInGroup(unit))) then
        return UnitClassBase(unit)
    end
end)

api.cloneTag('tk:level', 'level')

api.addTag('tk:diffcolor', function(unit)
    local level = UnitLevel(unit)
    return lib.getHexRGB(GetQuestDifficultyColor(level > 0 and level or 999), true)
end, events['tk:level'])



api.addTag('tk:classcolor', function(unit)
    local _, class = UnitClassBase(unit)
    return lib.getHexRGB(colors.class[class] or cfg.font.color, true)
end)

api.addTag('tk:druidform', function(unit)
    if (select(2, UnitClass(unit)) ~= 'DRUID') then return end
    for form, localized in pairs(L.druidforms) do
        if (UnitAura(unit, form, form == 'Tree of Life' and 'shapeshift' or nil, 'HELPFUL')) then
            return '('..localized..')'
        end
    end
end, 'UNIT_AURA')

api.addTag('tk:smartrace', function(unit)
    if (UnitIsPlayer(unit)) then
        return UnitRace(unit)
    else
        return UnitCreatureFamily(unit) or UnitCreatureType(unit) or _G.UNKNOWN
    end
end)

--combo tags
api.addTag('tk:name+flags', function(unit)
    local name, flag = tags['tk:name'](unit), tags['tk:flags'](unit)    
    if (flag) then return name..' '..flag end
    return name
end, events['tk:name'], events['tk:flags'])

--["unitinfo"] = "[classification] [diffcolor][level]|r [classcolor][classbase]|r [druidform] [SmartRace]",
api.addTag('tk:unitinfo', function(unit)
    local unitinfo, classification, level, classbase, druidform, race
    classification = tags['tk:classification'](unit)
    level = tags['tk:level'](unit)
    classbase = tags['tk:classbase'](unit)
    druidform = tags['tk:druidform'](unit)
    race = tags['tk:smartrace'](unit) or ''
    
    level = level and lib.applyHexToString(level, tags['tk:diffcolor'](unit))
    classbase = classbase and lib.applyHexToString(classbase, tags['tk:classcolor'](unit))
    
    unitinfo = (classification and classification..' ' or '')..(level and level..' ' or '')..(classbase and classbase..' ' or '')..(druidform and druidform..' ' or '')..race
    return unitinfo
end, events['tk:classification'], events['tk:level'], events['tk:classbase'], events['tk:druidform'], events['tk:smartrace'])

tk.tags = tags