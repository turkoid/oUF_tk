local addon, tk = ...
local global = GetAddOnMetadata(addon, 'X-tk')

tkLib.createAddon(addon, tk)

tk.lib = tkLib
tk.media = tkMedia

_G[global] = tk