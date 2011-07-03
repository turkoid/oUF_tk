local addon, tk = ...

local lib = tk.lib
local media = tk.media
local colors = {}

lib.createFallback(colors, oUF.colors, true)

colors.rgb = media.colors.rgb
colors.hex = media.colors.hex
colors.experience = colors.power['MANA']
colors.rested = lib.getPercentRGB(155, 40, 255)

tk.colors = colors


