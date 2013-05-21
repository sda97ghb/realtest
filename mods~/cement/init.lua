CEMENT_ALPHA = 160
CEMENT_VISC = 7

minetest.register_node("cement:flowing", {
	description = "Cement Water",
	inventory_image = minetest.inventorycube("cement.png"),
	drawtype = "flowingliquid",
	tiles = {"cement.png"},
	drop = "",
	special_tiles = {
		{
			image="cement_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
		{
			image="cement_flowing_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
	},
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "flowing",
	liquid_alternative_flowing = "cement:flowing",
	liquid_alternative_source = "cement:source",
	liquid_viscosity = CEMENT_VISC,
	damage_per_second = 4,
	post_effect_color = {a=255, r=0, g=0, b=0},
	groups = {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1},
})

minetest.register_node("cement:source", {
	description = "Cement Source",
	inventory_image = minetest.inventorycube("cement.png"),
	drawtype = "liquid",
	tiles = {
		{name="cement_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{name="cement.png", backface_culling=false},
	},
	drop = "",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "cement:flowing",
	liquid_alternative_source = "cement:source",
	liquid_viscosity = CEMENT_VISC,
	damage_per_second = 4,
	post_effect_color = {a=255, r=0, g=0, b=0},
	groups = {water=3, liquid=3, puts_out_fire=1},
})

minetest.register_abm({
	nodenames = {"cement:source","cement:flowing"},
	interval = 5,
	chance = 2,
	action = function(pos, node)
		minetest.env:set_node(pos, {name="default:stone"})
		nodeupdate_single(pos)
	end,
})