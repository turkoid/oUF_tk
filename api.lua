local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = tk.colors
local cfg = tk.cfg
local vars = tk.vars

local api = {}
api.addUpdateFrame = function(func)
    if (not tk.updateFrames) then
        tk.updateFrames = {}
    end
    
    local frame = CreateFrame('Frame')
    frame.lastUpdate = 0
    frame:SetScript('OnUpdate', func)
    
    table.insert(tk.updateFrames, frame)
    
    return frame
end

api.getLayoutFromUnit = function(unit)
    unit = unit and string.lower(unit)
    
    if (not unit) then
        unit = 'error'
    elseif (unit:find('party')) then
        if (unit:find('pet')) then
            unit = 'partypet'
        elseif (unit:find('target')) then
            unit = 'partytarget'
        else
            unit = 'party'
        end
    elseif (unit:find('raid')) then
        if (unit:find('pet')) then
            unit = 'raidpet'
        elseif (unit:find('target')) then
            unit = 'raidtarget'
        else
            unit = 'raid'
        end
    elseif (unit:find('boss')) then
        unit = 'boss'
    end
    
    return unit
end

api.getMenu = function(self)
    vars.dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, vars.dropdown, 'cursor', 0, 0)
end

api.setColor = function(o, func, c, a)
    local r, g, b = lib.getRGB(c)    
    tk.debug(o, func, c)
    o[func](o, r, g, b, a or 1)
end

api.setBackdropColor = function(f, c, a)
    local r, g, b = lib.getRGB(c)    
    f:SetBackdropColor(r, g, b, a or 1)
end

api.setBorderColor = function(f, c, a)
    local r, g, b = lib.getRGB(c)    
    f:SetBackdropBorderColor(r, g, b, a or 1)
end

api.setBackdrop = function(f, backdrop, c, a)
    local r, g, b = lib.getRGB(c) 
    
    f:SetBackdrop(backdrop)     
    api.setBackdropColor(f, c, a)
end

api.getDefaultFontString = function(parent, justifyh, size)      
    local r, g, b = lib.getRGB(cfg.font.color)
    local fs = parent:CreateFontString(nil, 'OVERLAY')
    fs:SetFont(cfg.font.name, size or cfg.font.size)
    fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1, -1)
	fs:SetJustifyV('CENTER')
    fs:SetJustifyH(justifyh or 'LEFT')    
    fs:SetTextColor(r, g, b)
    
    return fs
end

tk.api = api