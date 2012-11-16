--
-- Malachite
--

minetest.register_node("decorations:malachite_block", {
	description = "Malachite Block",
	tiles = {"decorations_malachite.png"},
	is_ground_content = true,
	drop = "minerals:malachite 4",
	groups = {cracky=3,drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decorations:malachite_pyramid", {
	description = "Malachite Pyramid",
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
	tiles = {"decorations_malachite.png"},
	is_ground_content = true,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decorations:malachite_table", {
	description = "Malachite Table",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.245, -0.5, 0.5, 0.4375, 0.5},
				{-0.4375, -0.5, -0.4375, -0.25, 0.25, -0.25},
				{-0.4375, -0.5, 0.25, -0.25, 0.25, 0.4375},
				{0.25, -0.5, -0.4375, 0.4375, 0.25, -0.25},
				{0.25, -0.5, 0.25, 0.4375, 0.25, 0.4375},
			},
		},
	selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5},
			},
		},
	tiles = {"decorations_malachite.png", "default_wood.png^decorations_malachite_table_bottom.png", "default_wood.png^decorations_malachite_table_side.png"},
	is_ground_content = true,
	groups = {cracky=3, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decorations:casket", {
	description = "Casket",
	drawtype = "nodebox",
	tiles = {"decorations_casket_top.png", "decorations_casket_top.png", "decorations_casket_side.png",
		"decorations_casket_side.png", "decorations_casket_side.png", "decorations_casket_front.png"},
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
	groups = {snappy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,8]"..
				"list[current_name;main;1,0;6,3;]"..
				"list[current_player;main;0,4;8,4;]")
		meta:set_string("infotext", "Casket")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_node("decorations:malachite_chest", {
	description = "Chest",
	tiles = {"decorations_malachite_chest_top.png", "decorations_malachite_chest_top.png", "decorations_malachite_chest_side.png",
		"decorations_malachite_chest_side.png", "decorations_malachite_chest_side.png", "decorations_malachite_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Malachite Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_node("decorations:malachite_cylinder", {
	description = "Malachite Cylinder",
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
	tiles = {"decorations_malachite.png"},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decorations:malachite_vase", {
	description = "Malachite Vase",
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
	tiles = {"decorations_malachite.png"},
	is_ground_content = true,
	groups = {cracky=3, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_stone_defaults(),
})

------CRAFT RECIPES------

minetest.register_craft({
	output = "decorations:casket",
	recipe = {
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "decorations:malachite_chest",
	recipe = {
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"minerals:malachite","","minerals:malachite"},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "decorations:malachite_block",
	recipe = {
		{"minerals:malachite","minerals:malachite"},
		{"minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "decorations:malachite_pyramid",
	recipe = {
		{"","minerals:malachite",""},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
	}
})

minetest.register_craft({
	output = "decorations:malachite_table",
	recipe = {
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"default:wood","","default:wood"},
		{"default:wood","","default:wood"},
	}
})

minetest.register_craft({
	output = "decorations:malachite_cylinder",
	recipe = {
		{"","minerals:malachite",""},
		{"minerals:malachite","minerals:malachite","minerals:malachite"},
		{"","minerals:malachite",""},
	}
})

minetest.register_craft({
	output = "decorations:malachite_vase",
	recipe = {
		{"minerals:malachite","","minerals:malachite"},
		{"","minerals:malachite",""},
		{"","minerals:malachite",""},
	}
})
