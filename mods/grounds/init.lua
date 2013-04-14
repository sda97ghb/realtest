minetest.register_craftitem("grounds:clay_lump", {
	description = "Clay Lump",
	inventory_image = "grounds_clay_lump.png"
})
minetest.register_alias("default:clay_lump", "grounds:clay_lump")
dofile(minetest.get_modpath("grounds").."/dirt.lua")