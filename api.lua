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
    func(o, r, g, b, a or 1)
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

api.genTag = function(f, parent, name, tag, justify, padding, width)
    local cfgExists = type(tag) == 'table'
    padding = padding or cfg.font.padding
    width = width or justify == 'CENTER' and (f:GetWidth() + (2 * padding))
    
    local fs = api.getDefaultFontString(parent, justify, cfgExists and tag.size)      
    fs:SetPoint(justify, parent, justify, justify == 'LEFT' and padding or justify == 'RIGHT' and -padding or 0, 0)
    if (width) then
        fs:SetWidth(width)
    end
    
    if (not f.texts) then f.texts = {} end   
    f.texts[name] = fs
    
    f:Tag(fs, cfgExists and tag.tag or tag)    
    
    return fs
end

api.addTag = function(tag, func, events, pool)
    if (oUF.Tags[tag]) then
        tk.message('WARNING! '..addon..' is overriding this tag: '..tag)
    end
    
    oUF.Tags[tag] = func
    oUF.TagEvents[tag] = events
    
    if (pool) then pool[tag] = func end
    
    return func
end

api.cloneTag = function(tag, orig, pool)
    return api.addTag(tag, oUF.Tags[orig], oUF.TagEvents[orig], pool)
end
    
api.formatValue = function(value, threshold) 
    threshold = threshold or 1e3
    if (value < threshold or value < 1e3) then
        return value
    elseif (value >= 1e6) then
        return gsub(format('%.2fM', value / 1e6), '%.?0+([km])$', '%1')
    elseif (value >= 1e3) then
        return gsub(format('%.1fK', value / 1e3), '%.?0+([km])$', '%1')
    end
end

api.formatDuration = function(duration)	
    if (not duration) then return '' end

    local h = floor(duration / 3600)
    local m = floor(mod(duration / 60, 60))
    local s = floor(mod(duration, 60))
    
    if (duration >= 3600) then
        return format("%d:%.2d:%.2d", h, m, s)
    else
        return format("%d:%.2d", m, s)
    end
end

tk.api = api