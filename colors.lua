local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = {}

colors.rgb = media.colors.rgb
colors.hex = media.colors.hex

colors.power = {    
    ['MANA'] = lib.getPercentRGB(48, 113, 191), --default: {0, 0, 255}
    ['RAGE'] = lib.getPercentRGB(226, 45, 75), --default: {255, 0, 0}
    ['FOCUS'] = lib.getPercentRGB(255, 220, 25), --default: {255, 125, 64}
    ['ENERGY'] = lib.getPercentRGB(255, 220, 25), --default: {255, 255, 0}
    --['UNUSED'] = lib.getPercentRGB(0, 255, 255), --default: {0, 255, 255}
    --['RUNES'] = lib.getPercentRGB(128, 128, 128), --default: {128, 128, 128}
    --['RUNIC_POWER'] = lib.getPercentRGB(0, 209, 255), --default: {0, 209, 255}
    --['SOUL_SHARDS'] = lib.getPercentRGB(128, 82, 140), --default: {128, 82, 140}
    ['ECLIPSE'] = lib.getPercentRGB(25, 255, 25),
    --['HOLY_POWER'] = lib.getPercentRGB(242, 230, 153), --default: {242, 230, 153}
    ['AMMOSLOT'] = lib.getPercentRGB(255, 220, 25), 
    --['FUEL'] = lib.getPercentRGB(255, 220, 25),
    ['FUEL'] = lib.getPercentRGB(255, 255, 255),
    ['HAPPINESS'] = lib.getPercentRGB(0, 255, 0), 
    ['NONE'] = lib.getPercentRGB(0, 0, 0),
}
colors.experience = colors.rgb.blue
colors.rested = lib.getPercentRGB(155, 40, 255)

lib.createFallback(colors, oUF.colors, true)

tk.colors = colors


