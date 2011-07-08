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
local func = tk.func

local setStyle = function(self, unit)
    self.layout = api.getLayoutFromUnit(unit or self:GetName())
    self.colors = colors
    
    local layout = layouts[self.layout]
    if (not layout) then
        tk.error('No layout found for this frame: '..self:GetName())
        return self
    end
    
    --self.disallowVehicleSwap = false
    --size and position
    self:SetSize(layout.general.width, layout.general.height)
    
    --create menu    
    self.menu = api.getMenu
    
    --frame attributes
    self:RegisterForClicks('LeftButtonDown', 'RightButtonDown')
    self:SetAttribute('*type2', 'menu')
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    self:SetAttribute('initial-height', layout.general.height)
    self:SetAttribute('initial-width', layout.general.width)
    self:SetAttribute('alt-type1', 'focus')
    
    --background and border
    if (layout.border) then
        api.setBackdrop(self, vars.backdrops.all, cfg.background.color, cfg.background.alpha)
        api.setBorderColor(self, cfg.border.color, cfg.border.alpha)
        self.border = cfg.border.size * lib.resolution.mult
    else
        api.setBackdrop(self, vars.backdrops.noborder, cfg.background.color, cfg.background.alpha)
        self.border = 0
    end
    
    --vars
    self.padding = layout.general.padding * lib.resolution.mult or 0
    local offset = self.padding + self.border
    
    --health bar
    do        
        local hb = CreateFrame('StatusBar', nil, self)
        hb:SetHeight(layout.healthbar.height)
        hb:SetStatusBarTexture(cfg.statusbar.texture)
        hb:SetPoint('TOPLEFT', self, 'TOPLEFT', offset, -offset)
        hb:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -offset, -offset)
        hb:SetOrientation(layout.healthbar.orientation or 'HORIZONTAL')

        hb.bg = hb:CreateTexture(nil, 'BORDER')
        hb.bg:SetAllPoints(hb)
        hb.bg:SetTexture(cfg.statusbar.texture)
        hb.bg.multiplier = cfg.statusbar.bgmult

        hb.colorTapping = true
        hb.colorClass = true
        hb.colorReaction = true
        hb.frequentUpdates = true

        --name text
        if (layout.tags.name) then
            api.genTag(self, hb, 'Name', layout.tags.name, 'LEFT').frequentUpdates = 0.5
        end
        
        --hp text
        if (layout.tags.health) then
            hb.value = api.genTag(self, hb, 'Health', layout.tags.health, 'RIGHT')
        end
        
        self.Health = hb        
    end
    
    --power bar
    if (layout.powerbar) then      
        local pb = CreateFrame('StatusBar', nil, self)
        pb:SetHeight(layout.powerbar.height)
        pb:SetStatusBarTexture(cfg.statusbar.texture)
        pb:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        pb:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, 0)
        pb:SetOrientation(layout.powerbar.orientation or 'HORIZONTAL')

        pb.bg = pb:CreateTexture(nil, 'BORDER')
        pb.bg:SetAllPoints(pb)
        pb.bg:SetTexture(cfg.statusbar.texture)
        pb.bg.multiplier = cfg.statusbar.bgmult
    
        pb.colorPower = true
        pb.frequentUpdates = true
        
        --spark
        if (layout.powerbar.spark and self.layout == 'player') then
            local spark = pb:CreateTexture(nil, 'OVERLAY')
            
            self.ManaSpark = spark
        end   
        
        --unitinfo text
        if (layout.tags and layout.tags.unitinfo) then
            api.genTag(self, pb, 'UnitInfo', layout.tags.unitinfo, 'LEFT')
        end
        
        --power text
        if (layout.tags and layout.tags.power) then
            pb.value = api.genTag(self, pb, 'Power', layout.tags.power, 'RIGHT')
        end
        
        self.Power = pb        
    end
    
    --xp bar
    if (IsAddOnLoaded('oUF_Experience') and layout.xpbar and (self.layout == 'pet' or (self.layout == 'player' and lib.player.level ~= MAX_PLAYER_LEVEL and not IsXPUserDisabled()))) then
        local xb = CreateFrame('StatusBar', nil, self)
        xb:SetHeight(layout.xpbar.height)
        xb:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', offset, offset)
        xb:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -offset, offset)
        xb:SetStatusBarTexture(cfg.statusbar.texture)
        api.setColor(xb, xb.SetStatusBarColor, colors.experience)

        local rb = CreateFrame('StatusBar', nil, xb)
        rb:SetHeight(layout.xpbar.height)
        rb:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', offset, offset)
        rb:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -offset, offset)
        rb:SetStatusBarTexture(cfg.statusbar.texture)
        api.setColor(rb, rb.SetStatusBarColor, colors.rested)

        --xp text
        if (layout.tags and layout.tags.experience) then
            xb.value = api.genTag(self, xb, 'Experience', layout.tags.experience, 'RIGHT')
        end

        --xp tooltip
        if (layout.xpbar.tooltip) then
            xb:EnableMouse()
            xb:HookScript('OnLeave', GameTooltip_Hide)
            xb:HookScript('OnEnter', func.getXPTooltip)
        end

        xb.PostUpdate = func.PostUpdateExperience
        
        self.Experience = xb
        self.Experience.Rested = rb
    end
    
    --druid mana bar
    if (IsAddOnLoaded('oUF_DruidMana') and layout.druidmanabar and lib.player.class == 'DRUID') then      
        local db = CreateFrame('StatusBar', nil, self)
        db:SetHeight(layout.druidmanabar.height)
        db:SetStatusBarTexture(cfg.statusbar.texture)
        db:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', offset, offset)
        db:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -offset, offset)
        db:SetOrientation(layout.druidmanabar.orientation or 'HORIZONTAL')

        db.bg = db:CreateTexture(nil, 'BORDER')
        db.bg:SetAllPoints(db)
        db.bg:SetTexture(cfg.statusbar.texture)
        db.bg.multiplier = cfg.statusbar.bgmult 
        
        db.frequentUpdates = true
        
        --druid mana text
        if (layout.tags and layout.tags.druidmana) then
            db.value = api.genTag(self, db, 'DruidMana', layout.tags.druidmana, 'RIGHT')
            db.PostUpdate = func.PostUpdateDruidMana
        end
        
        --hide xp bar if druid mana bar is showing
        if (self.Experience) then
            db.PreUpdate = func.PreUpdateDruidMana
        end
        
        self.DruidMana = db        
    end
    
    --combopoints
    
    --icons
    if (layout.icons) then
        self.IconFrame = CreateFrame('Frame', nil, self)
        self.IconFrame:SetFrameLevel(self.Health:GetFrameLevel() + 1)
        
        --raid icon
        if (layout.icons.raid) then
            local icon = self.IconFrame:CreateTexture(nil, 'OVERLAY')
            local size = type(layout.icons.raid) == 'number' and layout.icons.raid or layout.icons.size
            icon:SetSize(size, size)
            icon:SetPoint('CENTER', self, 'TOP', 0, -offset)
            self.RaidIcon = icon
        end

        --combat icon
        if (layout.icons.combat) then
            local icon = self.IconFrame:CreateTexture(nil, 'OVERLAY')
            local size = type(layout.icons.combat) == 'number' and layout.icons.combat or layout.icons.size
            icon:SetSize(size, size)
            icon:SetPoint('CENTER', self, 'TOPLEFT', offset, -offset)
            self.Combat = icon
        end
        
        --quest mob icon, lfd role icon, leader icon, assistant icon, masterlooter icon, phase icon
        do
            local count, iconkey, oUF_Key = 0
            for _, group in ipairs(cfg.icons.order) do
                iconkey, oUF_Key = unpack(group)
                
                if (layout.icons[iconkey]) then
                    local icon = self.IconFrame:CreateTexture(nil, 'OVERLAY')
                    local size = type(layout.icons[iconkey]) == 'number' and layout.icons[iconkey] or layout.icons.size
                    icon:SetSize(size, size)
                    icon:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', offset, offset)
                    
                    count = count + 1
                    self[oUF_Key] = icon
                end
            end
            
            if (count > 1) then
                local regEvent
                for event, eventcfg in pairs(cfg.icons.events) do
                    for iconkey, iconlayouts in pairs(eventcfg) do
                        if (layout.icons[iconkey]) then
                            regEvent = type(iconlayouts) ~= 'table' and iconlayouts
                            regEvent = regEvent or not iconlayouts[self.layout] or iconlayouts[self.layout] > 0
                            
                            if (regEvent) then 
                                self:RegisterEvent(event, func.updateGroupIcons) 
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    --buffs
    if (layout.buffs) then
        local buffs = CreateFrame('Frame', nil, self)
        buffs.size = layout.buffs.size or layout.general.width / layout.buffs.cols
        buffs['spacing-x'] = layout.buffs.spacingx or 0
        buffs['spacing-y'] = layout.buffs.spacingy or 0
        buffs:SetWidth((buffs.size + buffs['spacing-x']) * layout.buffs.cols)
        buffs:SetHeight((buffs.size + buffs['spacing-y']) * layout.buffs.rows)
        buffs.initialAnchor = layout.buffs.initial_anchor
        buffs['growth-x'] = layout.buffs.growthx
        buffs['growth-y'] = layout.buffs.growthy
        buffs.disableCooldown = true
        buffs.filter = 'HELPFUL'
        buffs.num = layout.buffs.rows * layout.buffs.cols
        buffs:SetPoint(layout.buffs.self_anchor, self, layout.buffs.target_anchor, layout.buffs.x or 0, layout.buffs.y or 0)
        buffs.sort = true
        
        self.SortedBuffs = buffs
    end
    
    --debuffs
    if (layout.debuffs) then
        local debuffs = CreateFrame('Frame', nil, self)
        debuffs.size = layout.debuffs.size or layout.general.width / layout.debuffs.cols
        debuffs['spacing-x'] = layout.debuffs.spacingx or 0
        debuffs['spacing-y'] = layout.debuffs.spacingy or 0
        debuffs:SetWidth((debuffs.size + debuffs['spacing-x']) * layout.debuffs.cols)
        debuffs:SetHeight((debuffs.size + debuffs['spacing-y']) * layout.debuffs.rows)
        debuffs.initialAnchor = layout.debuffs.initial_anchor
        debuffs['growth-x'] = layout.debuffs.growthx
        debuffs['growth-y'] = layout.debuffs.growthy
        debuffs.disableCooldown = true
        debuffs.filter = 'HARMFUL'
        debuffs.num = layout.debuffs.rows * layout.debuffs.cols
        debuffs:SetPoint(layout.debuffs.self_anchor, self, layout.debuffs.target_anchor, layout.debuffs.x or 0, layout.debuffs.y or 0)
        debuffs.sort = false
        
        self.SortedDebuffs = debuffs
    end
    
    --range check
    if (layout.general.rangecheck) then 
    
    end
        
end

oUF:RegisterStyle('oUF_tk', setStyle)

--player, target, pet, targettarget, party, partytarget, partypet, boss
do
    oUF:SetActiveStyle('oUF_tk')
    
    local frames = {}
    local spawn = function(unit, layout)
        local layout = layout or layouts[unit]
        local pos, target = layout.position
        
        if (pos.target and layouts[pos.target]) then
            target = frames[pos.target] or spawn(pos.target, layouts[pos.target])
        else
            target = UIParent
        end
        
        local f = oUF:Spawn(unit, 'oUF_tk'..(layout.general.name or string.upper(unit)))
        f:SetPoint(pos.self_anchor, target, pos.target_anchor, pos.x, pos.y)
        frames[unit] = f
        
        return f
    end    
    
    for unit, layout in pairs(layouts) do
        if (not frames[unit]) then
            spawn(unit, layout)
        end
    end
    
    tk.frames = frames
end