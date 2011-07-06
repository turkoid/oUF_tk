local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = tk.colors
local cfg = tk.cfg
local vars = tk.vars
local api = tk.api
local tags = tk.tags

local layouts = {}
layouts.player = {
    general = {
        name = 'Player',
        height = 66,
        width = 310,
        padding = 1,
        vehicle = true,
        debuff_highlight = true,
    },
    position = {
        self_anchor = 'TOPRIGHT',
        target = 'ui',
        target_anchor = 'TOP',
        x = -1,
        y = -825,
    },    
    healthbar = {
        height = 36,
        orientation = 'HORIZONTAL',
    },
    powerbar = {
        height = 16,
        orientation = 'HORIZONTAL',
        spark = true,
    },
    druidmanabar = {
        height = 12,
        orientation = 'HORIZONTAL',
    },
    xpbar = {
        height = 12,
        tooltip = true,
    },
    icons = {
        size = 10,
        quest = false,
        role = true,
        leader = true,
        assistant = true,        
        masterlooter = true,
        phase = false,
        combat = 16,
        raid = 16,
    },  
    tags = {
        name = {
            tag = '[tk:name+flags]',
            frequent = 0.5,
        },
        unitinfo = '[tk:unitinfo]',
        health = {
            tag = '[tk:status|hp+(miss|per)]',
            frequent = 0.1,
        },
        power = {
            tag = '[tk:status|pp+(miss|per)]',
            frequent = 0.1,
        },
        druidmana = {
            tag = '[tk:druidmana]',
            size = 12,
        },
        experience = {
            tag = '[tk:experience]',
            size = 12,
        },
    },
    buffs = {
        rows = 1,
        cols = 19,
        self_anchor = 'TOPLEFT',
        target_anchor = 'BOTTOMLEFT',
        initial_anchor = 'TOPLEFT',
        spacingx = 0,
        spacingy = 0,
        growthx = 'RIGHT',
        growthy = 'DOWN',
    },
    debuffs = {
        rows = 3,
        cols = 13,
        self_anchor = 'BOTTOMLEFT',
        target_anchor = 'TOPLEFT',
        initial_anchor = 'BOTTOMLEFT',
        spacingx = 0,
        spacingy = 0,
        growthx = 'RIGHT',
        growthy = 'UP',
    },
}
layouts.target = {
    general = {
        name = 'Target',
        height = 66,
        width = 310,
        padding = 1,
        vehicle = true,
        debuff_highlight = true,
    },
    position = {
        self_anchor = 'TOPLEFT',
        target = 'ui',
        target_anchor = 'TOP',
        x = 1,
        y = -825,
    },    
    healthbar = {
        height = 36,
        orientation = 'HORIZONTAL',
    },
    powerbar = {
        height = 16,
        orientation = 'HORIZONTAL',
        spark = true,
    },
    icons = {
        size = 10,
        quest = true,
        role = true,
        leader = true,
        assistant = true,        
        masterlooter = true,
        phase = true,
        combat = false,
        raid = 16,
    },  
    tags = {
        name = {
            tag = '[tk:name+flags]',
            frequent = 0.5,
        },
        unitinfo = '[tk:unitinfo]',
        health = '[tk:status|hp+(miss|per)]',
        power = '[tk:status|pp+(miss|per)]',
    },
    buffs = {
        rows = 1,
        cols = 19,
        self_anchor = 'TOPLEFT',
        target_anchor = 'BOTTOMLEFT',
        initial_anchor = 'TOPLEFT',
        spacingx = 0,
        spacingy = 0,
        growthx = 'RIGHT',
        growthy = 'DOWN',
    },
    debuffs = {
        rows = 3,
        cols = 13,
        self_anchor = 'BOTTOMLEFT',
        target_anchor = 'TOPLEFT',
        initial_anchor = 'BOTTOMLEFT',
        spacingx = 0,
        spacingy = 0,
        growthx = 'RIGHT',
        growthy = 'UP',
    },
}
layouts.pet = {
    general = {
        name = 'Pet',
        height = 66,
        width = 238,
        padding = 1,
        vehicle = true,
        debuff_highlight = true,
    },
    position = {
        self_anchor = 'TOPRIGHT',
        target = 'player',
        target_anchor = 'TOPLEFT',
        x = -2,
        y = 0,
    },    
    healthbar = {
        height = 36,
        orientation = 'HORIZONTAL',
    },
    powerbar = {
        height = 16,
        orientation = 'HORIZONTAL',
        spark = true,
    },
    xpbar = {
        height = 12,
        tooltip = true,
    },
    icons = {
        size = 10,
        quest = false,
        role = false,
        leader = false,
        assistant = false,        
        masterlooter = false,
        phase = true,
        combat = 16,
        raid = 16,
    },  
    tags = {
        name = '[tk:name]',
        unitinfo = '[tk:unitinfo]',
        health = '[tk:status|perhp]',
        power = '[tk:status|pp]',
        druidmana = {
            tag = '[tk:druidmana]',
            size = 12,
        },
        experience = {
            tag = '[tk:experience]',
            size = 12,
        },
    },
    buffs = {
        size = 16.3,
        rows = 1,
        cols = 7,
        self_anchor = 'TOPLEFT',
        target_anchor = 'BOTTOMLEFT',
        initial_anchor = 'TOPLEFT',
        spacingx = 0,
        spacingy = 0,
        growthx = 'RIGHT',
        growthy = 'DOWN',
    },
    debuffs = {
        size = 16.3,
        rows = 1,
        cols = 7,
        self_anchor = 'TOPRIGHT',
        target_anchor = 'BOTTOMRIGHT',
        initial_anchor = 'TOPRIGHT',
        spacingx = 0,
        spacingy = 0,
        growthx = 'RIGHT',
        growthy = 'UP',
    },
}      

tk.layouts = layouts 