local addon, tk = ...
local global = GetAddOnMetadata(addon, 'X-tk')
local global_oUF = GetAddOnMetadata(addon, 'X-oUF')

tk.oUF = global_oUF and _G[global_oUF] or oUF
tkLib.createAddon(addon, tk)

tk.lib = tkLib
tk.media = tkMedia

tk.createModule = function(module)
    module.parent = tk
end
 


_G[global] = tk