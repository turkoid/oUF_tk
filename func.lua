local addon, tk = ...

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
            offset = offset + icon:GetWidth() + 1
        end
    end
end

func.genTag = function(f, parent, name, tag, justify, padding, width)
    local cfgExists = type(tag) == 'table'
    padding = padding or cfg.font.padding
    width = width or justify == 'CENTER' and (f:GetWidth() + (2 * padding))
    
    if (not f.texts) then f.texts = {} end
    f.texts[name] = api.getDefaultFontString(parent, justify, cfgExists and tag.size)    
    f.texts[name]:SetPoint(justify, parent, justify, justify == 'LEFT' and padding or justify == 'RIGHT' and -padding or 0, 0)
    if (width) then
        f.texts[name]:SetWidth(width)
    end
    --self:Tag(f.texts[name], cfgExists and tag.tag or tag)
end

do
    local xp = function(unit)
        if(unit == 'pet') then
            return GetPetExperience()
        else
            return UnitXP(unit), UnitXPMax(unit)
        end
    end
    
    func.getXPTooltip = function(self)
        local unit = self:GetParent().unit
        local curxp, maxxp = xp(unit)
        local exhaustion = GetXPExhaustion()
        local bars = unit == 'pet' and 6 or 20

        GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT', 5, -5)
        GameTooltip:AddLine(format('XP: %d / %d (%d%% - %d bars)', curxp, maxxp, curxp / maxxp * 100, bars))
        GameTooltip:AddLine(format('Left: %d (%d%% - %d bars)', maxxp - curxp, (maxxp - curxp) / maxxp * 100, bars * (maxxp - curxp) / maxxp))
        
        if (exhaustion) then
            GameTooltip:AddLine(format('|cff0090ffRested: +%d (%d%%)', exhaustion, exhaustion / maxxp * 100))
        end

        GameTooltip:Show()
    end
end

do
    local UnitPowerType = UnitPowerType    
    
    func.PreUpdateDruidMana = function(self, unit)
        local xb = self.__owner.Experience
        if (not xb or event ~= 'UNIT_DISPLAYPOWER') then return end        
        local alpha = UnitPowerType(unit) == SPELL_POWER_MANA and 1 or 0
        
        if (xb:GetAlpha() ~= alpha) then
            xb:SetSlpha(alpha)
        end
    end
end
                
tk.func = func