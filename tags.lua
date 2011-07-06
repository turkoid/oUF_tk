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

api.addTag('tk:status', function(unit)
    if (UnitIsDead(unit)) then return 'Dead' end
    if (UnitIsGhost(unit)) then return 'Ghost' end
    if (not UnitIsConnected(unit)) then return 'Office' end
end, events['status'])

oUF.Tags["[missinghp]"] = function(unit)
	if not unit then return "nil" end
	local threshold = 0.01
	local max = UnitHealthMax(unit)
	local missing = max - UnitHealth(unit)
	return (missing - (threshold * max)) > 0 and (Hex(1, 0, 0).."-"..MedValues(missing).."|r") or ""
end

api.addTag('tk:curhp', function(unit)
    return api.formatValue(UnitHealth(unit), 1e5)
end, events['curhp'])

api.addTag('tk:maxhp', function(unit)
    return api.formatValue(UnitHealthMax(unit), 1e5)
end, events['maxhp'])

api.addTag('tk:perhp', function(unit)
    return tags['perhp'](unit)..'%'
end, events['perhp'])

api.addTag('tk:missinghp', function(unit)
    local threshold, max, missing = 0.01, UnitHealthMax(unit)
    missing = max - UnitHealth(unit)
    return missing > (threshold * max) and lib.applyHex(missing, colors.hex.red)
end, events['missinghp'])

api.addTag('tk:curpp', function(unit)
    return api.formatValue(UnitPower(unit), 1e5)
end, events['curhp'])

api.addTag('tk:maxpp', function(unit)
    return api.formatValue(UnitPowerMax(unit), 1e5)
end, events['curhp'])

api.addTag('tk:perpp', function(unit)
    return tags['perpp'](unit)..'%'
end, events['curhp'])

api.addTag('tk:missingpp', function(unit)
    local threshold, max, missing = 0.01, UnitPowerMax(unit)
    missing = max - UnitPower(unit)
    return missing > (threshold * max) and lib.applyHex(missing, colors.hex.white)
end, events['missingpp'])

--combo tags
api.addTag('tk:name+flags', function(unit)
    local name, flag = tags['tk:name'](unit), tags['tk:flags'](unit)  
    return api.concatTags(name, flag)
end, events['tk:name'], events['tk:flags'])

api.addTag('tk:unitinfo', function(unit)
    local classification, level, classbase, druidform, race
    classification = tags['tk:classification'](unit)
    level = tags['tk:level'](unit)
    classbase = tags['tk:classbase'](unit)
    druidform = tags['tk:druidform'](unit)
    race = tags['tk:smartrace'](unit)
    
    level = level and lib.applyHex(level, tags['tk:diffcolor'](unit))
    classbase = classbase and lib.applyHex(classbase, tags['tk:classcolor'](unit))
    
    return api.concatTags(classification, level, classbase, druidform, race)
end, events['tk:classification'], events['tk:level'], events['tk:classbase'], events['tk:druidform'], events['tk:smartrace'])

--health combo tags
api.addTag('tk:status|hp', function(unit)
    local status = tags['tk:status'](unit)
    if (status) then return status end
    return format('%s/%s', tags['tk:curhp'](unit), tags['tk:maxhp'](unit))
end, events['tk:status'], events['tk:curhp'], events['tk:maxhp'])

api.addTag('tk:status|perhp', function(unit)
    return tags['tk:status'](unit) or tags['tk:perhp'](unit)
end, events['tk:status'], events['tk:perhp'])

api.addTag('tk:status|hp+per', function(unit)
    local status = tags['tk:status'](unit)
    if (status) then return status end
    return format('%s/%s | %s', tags['tk:curhp'](unit), tags['tk:maxhp'](unit), tags['tk:perhp'](unit))
end, events['tk:status'], events['tk:curhp'], events['tk:maxhp'], events['tk:perhp'])

api.addTag('tk:status|hp+(miss|per)', function(unit)
    local status = tags['tk:status'](unit)
    if (status) then return status end
    return format('%s/%s | %s', tags['tk:curhp'](unit), tags['tk:maxhp'](unit), UnitCanAssist('player', unit) and tags['tk:missinghp'](unit) or tags['tk:perhp'](unit))
end, events['tk:status'], events['tk:curhp'], events['tk:maxhp'], events['tk:missinghp'], events['tk:perhp'])

--power combo tags
api.addTag('tk:status|pp', function(unit)
    if (tags['tk:status'](unit)) then return end
    return UnitPowerMax(unit) > 0 and format('%s/%s', tags['tk:curpp'](unit), tags['tk:maxpp'](unit))
end, events['tk:status'], events['tk:curpp'], events['tk:maxpp'])

api.addTag('tk:status|perpp', function(unit)
    return not tags['tk:status'](unit) and UnitPowerMax(unit) > 0 and tags['tk:perpp'](unit)
end, events['tk:status'], events['tk:perpp'])

api.addTag('tk:status|pp+per', function(unit)
    if (tags['tk:status'](unit)) then return end
    return UnitPowerMax(unit) > 0 and format('%s/%s | %s', tags['tk:curpp'](unit), tags['tk:maxpp'](unit), tags['tk:perpp'](unit))
end, events['tk:status'], events['tk:curpp'], events['tk:maxpp'], events['tk:perpp'])

api.addTag('tk:status|pp+(miss|per)', function(unit)
    if (tags['tk:status'](unit)) then return end
    return UnitPowerMax(unit) > 0 and format('%s/%s | %s', tags['tk:curpp'](unit), tags['tk:maxpp'](unit), UnitCanAssist('player', unit) and tags['tk:missingpp'](unit) or tags['tk:perpp'](unit))
end, events['tk:status'], events['tk:curpp'], events['tk:maxpp'], events['tk:missingpp'], events['tk:perpp'])

tk.tags = tags