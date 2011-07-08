local addon, tk = ...

local oUF = tk.oUF
local lib = tk.lib
local media = tk.media
local colors = tk.colors
local cfg = tk.cfg

local vars = {}

do
    local dropdown = CreateFrame('Frame', addon..'DropDown', UIParent, 'UIDropDownMenuTemplate')
    
    UIDropDownMenu_Initialize(dropdown, function(self)
        local unit = self:GetParent().unit
        if (not unit) then return end
        local menu, name, id
        
        if (UnitIsUnit(unit, 'player')) then
            menu = 'SELF'
        elseif (UnitIsUnit(unit, 'vehicle')) then
            menu = 'VEHICLE'
        elseif (UnitIsUnit(unit, 'pet')) then
            menu = 'PET'
        elseif (UnitIsPlayer(unit)) then
            id = UnitInRaid(unit)
            if (id) then
                menu = 'RAID_PLAYER'
                name = GetRaidRosterInfo(id)
            elseif (UnitInParty(unit)) then
                menu = 'PARTY'
            else
                menu = 'PLAYER'
            end
        else
            menu = 'TARGET'
            name = RAID_TARGET_ICON
        end
        if (menu) then
            UnitPopup_ShowMenu(self, menu, unit, name, id)
        end
    end, 'MENU')
    
    for k, v in pairs(UnitPopupMenus) do
        for x, y in pairs(UnitPopupMenus[k]) do
            if y == 'SET_FOCUS' then
                table.remove(UnitPopupMenus[k], x)
            elseif y == 'CLEAR_FOCUS' then
                table.remove(UnitPopupMenus[k], x)
            end
        end
    end

    vars.dropdown = dropdown
end

vars.backdrops = {
    all = {
        bgFile = cfg.background.texture,
        edgeFile = cfg.border.texture,
        edgeSize = cfg.border.size,
        tile = cfg.background.tile,
        tileSize = cfg.background.tileSize,
        insets = {
            left = 0,
            right = 0, 
            top = 0,
            bottom = 0,
        },
    },
    noborder = {
        bgFile = cfg.background.texture,
        edgeFile = nil,
        edgeSize = 0,
        tile = cfg.background.tile,
        tileSize = cfg.background.tileSize,
        insets = {
            left = 0,
            right = 0, 
            top = 0,
            bottom = 0,
        },
    },
}

vars.AFKTimers = {}

tk.vars = vars