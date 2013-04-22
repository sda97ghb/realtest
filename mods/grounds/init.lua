minetest.register_craftitem("grounds:clay_lump", {
	description = "Clay Lump",
	inventory_image = "grounds_clay_lump.png"
})

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "grounds:clay_lump",
})

dofile(minetest.get_modpath("grounds").."/dirt.lua")