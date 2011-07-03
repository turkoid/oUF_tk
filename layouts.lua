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
    height = 66,
    width = 310,
    padding = 1,
    position = {
        self_anchor = 'TOPRIGHT',
        target = 'ui',
        target_anchor = 'TOP',
        x = -1,
        y = -825,
    },    
    healthbar = {
        height = 36,
        orientation = 'HORIZONTAL'
    },
    powerbar = {
        height = 16,
        orientation = 'HORIZONTAL'
    },
    druidmanabar = {
        height = 12,
        orientation = 'HORIZONTAL'
    },
    --[[
    xpbar = {
        height = 12,
        tooltip = true,
    },
    ]]--
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
    plugins = {
        vehicle = true,
        spark = true,
        debuff_highlight = true,
        range = true,
    },
    tags = {
        name = '',
        unitinfo = '',
        health = '',
        power = '',
        druidmana = {
            tag = '',
            size = 12,
        },
        experience = {
            tag = '',
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

tk.layouts = layouts 