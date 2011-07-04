local addon, tk = ...
local global = GetAddOnMetadata(addon, 'X-tk')

tkLib.createAddon(addon, tk)

tk.lib = tkLib
tk.media = tkMedia

tk.createModule = function(module)
    module.parent = tk
end

_G[global] = tk