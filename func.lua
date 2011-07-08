local addon, tk = ...

local oUF = tk.oUF
local lib = tk.lib
local media = tk.media
local colors = tk.colors
local cfg = tk.cfg
local vars = tk.vars
local api = tk.api
local tags = tk.tags
local layouts = tk.layouts
local func = {}

func.updateGroupIcons = function(self, event, unit)
    if (self.unit ~= unit) then return end    
    local offset = self.padding + self.border
    local icon, oUF_Key
    for _, group in ipairs(cfg.icons.order) do
        icon = group[2]
        
        if (icon) then
            icon:ClearAllPoints()
            icon:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', offset, self.padding + self.border)
            offset = offset + icon:GetWidth() + lib.resolution.mult
        end
    end
end

--Experience
do
    local xp = function(unit)
        if(unit == 'pet') then
            return GetPetExperience()
        else
            return UnitXP(unit), UnitXPMax(unit)
        end
    end
    
    func.getXPTooltip = function(self)
        local unit = self.__owner.unit
        local curxp, maxxp = xp(unit)
        local exhaustion = GetXPExhaustion()
        local bars = unit == 'pet' and 6 or 20

        GameTooltip:SetOwner(self, 'ANCHOR_NONE', 5, -5)
        GameTooltip:AddLine(format('XP: %d / %d (%d%% - %d bars)', curxp, maxxp, curxp / maxxp * 100, bars))
        GameTooltip:AddLine(format('Left: %d (%d%% - %d bars)', maxxp - curxp, (maxxp - curxp) / maxxp * 100, bars * (maxxp - curxp) / maxxp))
        
        if (exhaustion) then
            GameTooltip:AddLine(format('|cff0090ffRested: +%d (%d%%)', exhaustion, exhaustion / maxxp * 100))
        end

        GameTooltip:Show()
    end
    
    func.PostUpdateExperience = function(element, unit)
        if (unit == 'vehicle') then
            element:Hide()
        end
    end
end

--DruidMana
do
    local UnitPowerType = UnitPowerType    
    local UnitPower, UnitPowerMax = UnitPower, UnitPowerMax
    
    func.PreUpdateDruidMana = function(element, unit)
        local xb = element.__owner.Experience
        if (not xb) then return end        
        local alpha = UnitPowerType('player') == SPELL_POWER_MANA and 1 or 0
        
        if (xb:GetAlpha() ~= alpha) then        
            xb:SetAlpha(alpha)
        end
    end    
    
    func.PostUpdateDruidMana = function(element, unit) 
        if (element.value and UnitPower('player', SPELL_POWER_MANA) ~= UnitPowerMax('player', SPELL_POWER_MANA)) then
            element.value:UpdateTag()
        end
    end
end
        
tk.func = func