minetest.register_node("realistic_add_blocks:stone_flat", {
	description = "Flat stone",
	tiles = {"realistic_add_blocks_stone_flat.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("realistic_add_blocks:desert_stone_flat", {
	description = "Desert flat stone",
	tiles = {"realistic_add_blocks_desert_stone_flat.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("realistic_add_blocks:malachite_block", {
	description = "Malachite block",
	tiles = {"realistic_add_blocks_malachite.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("realistic_add_blocks:malachite_pyramid", {
	description = "Malachite pyramid",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
				{-0.4, -0.3, -0.4, 0.4, -0.1, 0.4},
				{-0.3, -0.1, -0.3, 0.3, 0.1, 0.3},
				{-0.2, 0.1, -0.2, 0.2, 0.3, 0.2},
				{-0.1, 0.3, -0.1, 0.1, 0.5, 0.1},
			},
		},
	tiles = {"realistic_add_blocks_malachite.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("realistic_add_blocks:malachite_table", {
	description = "Malachite table",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.35, -0.5, 0.5, 0.5, 0.5},
				{-0.4, -0.5, -0.4, -0.25, 0.35, -0.25},
				{-0.4, -0.5, 0.25, -0.25, 0.35, 0.4},
				{0.25, -0.5, -0.4, 0.4, 0.35, -0.25},
				{0.25, -0.5, 0.25, 0.4, 0.35, 0.4},
			},
		},
	tiles = {"realistic_add_blocks_malachite.png", "default_wood.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("realistic_add_blocks:casket", {
	description = "Cacket",
	drawtype = "nodebox",
	tiles = {"realistic_add_blocks_cacket_top.png", "realistic_add_blocks_cacket_top.png", "realistic_add_blocks_cacket_side.png",
		"realistic_add_blocks_cacket_side.png", "realistic_add_blocks_cacket_side.png", "realistic_add_blocks_cacket_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
			type = "fixed",
			fixed = {
				{-0.4, -0.5, -0.3, 0.4, 0, 0.3},
				{-0.3, 0, -0.2, 0.3, 0.1, 0.2},
			},
		},
	selection_box = {
			type = "fixed",
			fixed = {
				{-0.4, -0.5, -0.3, 0.4, 0, 0.3},
				{-0.3, 0, -0.2, 0.3, 0.1, 0.2},
			},
		},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,8]"..
				"list[current_name;main;1,0;6,3;]"..
				"list[current_player;main;0,4;8,4;]")
		meta:set_string("infotext", "Cacket")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_node("realistic_add_blocks:malachite_chest", {
	description = "Chest",
	tiles = {"realistic_add_blocks_malachite_chest_top.png", "realistic_add_blocks_malachite_chest_top.png", "realistic_add_blocks_malachite_chest_side.png",
		"realistic_add_blocks_malachite_chest_side.png", "realistic_add_blocks_malachite_chest_side.png", "realistic_add_blocks_malachite_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_node("realistic_add_blocks:malachite_cylinder", {
	description = "Malachite cylinder",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.2, 0.5, 0.5, 0.2},
				{-0.4, -0.5, -0.3, 0.4, 0.5, 0.3},
				{-0.3, -0.5, -0.4, 0.3, 0.5, 0.4},
				{-0.2, -0.5, -0.5, 0.2, 0.5, 0.5},
			},
		},
	selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.2, 0.5, 0.5, 0.2},
				{-0.4, -0.5, -0.3, 0.4, 0.5, 0.3},
				{-0.3, -0.5, -0.4, 0.3, 0.5, 0.4},
				{-0.2, -0.5, -0.5, 0.2, 0.5, 0.5},
			},
		},
	tiles = {"realistic_add_blocks_malachite.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("realistic_add_blocks:malachite_vase", {
	description = "Malachite cylinder",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, -0.4, 0.5, 0.5},
				{-0.5, 0, 0.4, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0.5, 0.5, -0.4},
				{0.4, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.4, -0.1, -0.4, 0.4, 0, 0.4},
				{-0.2, -0.4, -0.2, 0.2, -0.1, 0.2},
				{-0.4, -0.5, -0.4, 0.4, -0.4, 0.4},
			},
		},
	selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, -0.4, 0.5, 0.5},
				{-0.5, 0, 0.4, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0.5, 0.5, -0.4},
				{0.4, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.4, -0.1, -0.4, 0.4, 0, 0.4},
				{-0.2, -0.4, -0.2, 0.2, -0.1, 0.2},
				{-0.4, -0.5, -0.4, 0.4, -0.4, 0.4},
			},
		},
	tiles = {"realistic_add_blocks_malachite.png"},
	is_ground_content = true,
	groups = {cracky=3},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

------CRAFT RECIPES------

minetest.register_craft({
	output = "realistic_add_blocks:casket",
	recipe = {
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"minerals:malachite","default:wood","minerals:malachite"},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "realistic_add_blocks:malachite_chest",
	recipe = {
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"minerals:malachite","default:chest","minerals:malachite"},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "realistic_add_blocks:malachite_block",
	recipe = {
		{"minerals:malachite","minerals:malachite"},
		{"minerals:malachite","minerals:malachite"},
	}
})
minetest.register_craft({
	output = "minerals:malachite 4",
	recipe = {
		{"realistic_add_blocks:malachite_block"},
	}
})

minetest.register_craft({
	output = "realistic_add_blocks:malachite_pyramid",
	recipe = {
		{"","minerals:malachite",""},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "realistic_add_blocks:malachite_table",
	recipe = {
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"default:wood","default:wood","default:wood"},
		{"default:wood","","default:wood"},
	}
})

minetest.register_craft({
	output = "realistic_add_blocks:malachite_cylinder",
	recipe = {
		{"","minerals:malachite",""},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"","minerals:malachite",""},
	}
})

minetest.register_craft({
	output = "realistic_add_blocks:malachite_vase",
	recipe = {
		{"minerals:malachite","","minerals:malachite"},
		{"","minerals:malachite",""},
		{"","minerals:malachite",""},
	}
})