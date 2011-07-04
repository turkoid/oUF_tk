local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = tk.colors

local cfg = {      
    font = {
        name = media.default.font,
        size = 14,
        color = colors.rgb.white,
        padding = 4,
    },
    background = {
        texture = media.getTexture('white16x16.tga'),
        color = colors.rgb.white,
        alpha = 1 or media.default.alpha,
        tile = false,
    },
    border = {
        texture = media.getTexture('white16x16.tga'),
        color = colors.rgb.black,
        alpha = media.default.alpha,        
        size = 1,
    },
    statusbar = {
        texture = 'Interface\\AddOns\\NeedToKnow\\Textures\\Smoothv2.tga', -- media.getTexture('Flat.tga'),
        bgmult = 0.3,
    },
    debuffhighlight ={
        texture = media.getTexture('debuffHighlight.tga'),
        alpha = 0.75,
    },
    combopoints = {
        texture = media.getTexture('cpoint.tga'),
        color = colors.combopoints,
    },
    range = {
        inside = 1,
        outisde = 0.4,
    },
    locales = {
        druidforms = {
            ['Cat Form'] = 'Cat',
            ['Bear Form'] = 'Bear',
            ['Travel Form'] = 'Travel',
            ['Aquatic Form'] = 'Aquatic',
            ['Flight Form'] = 'Flight',
            ['Swift Flight Form'] = 'Flight',
            ['Tree of Life'] = 'Tree',
        },
        classifications = {
            ['worldboss'] = 'Boss',
            ['rareelite'] = 'Rare Elite',
            ['elite'] = 'Elite',
            ['rare'] = 'Rare',
            ['normal'] = '',
            ['trivial'] = '',
        },
    },
    icons = {
        order = {
            {'quest', 'QuestIcon'},
            {'role', 'LFDRole'},
            {'leader', 'Leader'},
            {'assistant', 'Assistant'},
            {'masterlooter', 'MasterLooter'},
            {'phase', 'PhaseIcon'},
        },
        events = {
            ['UNIT_CLASSIFICATION_CHANGED'] = {
                quest = true,
            },
            ['PLAYER_ROLES_ASSIGNED'] = {
                role = {
                    player = 1,
                },
            },
            ['PARTY_MEMBERS_CHANGED'] = {
                role = {
                    player = 0,
                },
                leader = true,
                assistant = true,
                masterlooter = true,
            },
            ['PARTY_LEADER_CHANGED'] = {
                leader = true,
            },
            ['PARTY_LOOT_METHOD_CHANGED'] = {
                masterlooter = true,
            },
            ['UNIT_PHASE'] = {
                phase = true,
            },
        },            
    },       
}        

cfg.player = {
    name = UnitName('player'),
    level = UnitLevel('player'),
    race = UnitRace('player'),
    class = select(2, UnitClass('player')),
    faction = UnitFactionGroup('player'),
}

tk.cfg = cfg



