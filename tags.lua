local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = tk.colors
local cfg = tk.cfg
local vars = tk.vars
local api = tk.api
local tags = {}

api.addTag('tk:druidmana', function(u, r)    
    return api.formatValue(UnitPower('player', SPELL_POWER_MANA), 1e5)
end, 'UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER', tags)

api.addTag('tk:experience', function(u, r)
    local threshold, min, max = 0.01
    if (unit == 'pet') then
        min, max = GetPetExerience()
    else
        min, max = UnitXP(r or u), UnitXPMax(r or u)
    end
    
    if ((max - min) <= (threshold * max)) then
        return api.formatValue(max - min)
    else
        return math.floor(min / max * 100 + 0.5)..'%'
    end
end, 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UNIT_PET_EXPERIENCE UPDATE_EXHAUSTION', tags)

api.cloneTag('tk:name', 'name', tags)