realtest = {}

local worldconf = minetest.get_worldpath().."/realtest.conf.lua"

--dofile(minetest.get_modpath("core").."/default_config.lua")
local f = io.open(worldconf)
if f then
	dofile(worldconf)
	f:close()
end
dofile(minetest.get_modpath("core").."/helper_functions.lua")
dofile(minetest.get_modpath("core").."/drop.lua")
dofile(minetest.get_modpath("core").."/place.lua")
dofile(minetest.get_modpath("core").."/falling.lua")
dofile(minetest.get_modpath("core").."/seasons.lua")
dofile(minetest.get_modpath("core").."/creative.lua")
dofile(minetest.get_modpath("core").."/player.lua")
dofile(minetest.get_modpath("core").."/stairs_and_slabs.lua")