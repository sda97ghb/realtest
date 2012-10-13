for i = 4,1,-1 do
	minetest.register_node("icicles:icicle_"..5-i, {
	description = "Icicle "..5-i,
	groups = {cracky=3, icicle=1},
	tiles = {"default_stone.png"},
	is_ground_content = true,
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-i/10, -0.5, -i/10, i/10, 0.5, i/10}
	},
	selection_box = {
		type = "fixed",
		fixed = {-i/10, -0.5, -i/10, i/10, 0.5, i/10}
	},
})
end
