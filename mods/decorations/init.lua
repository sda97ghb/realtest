local decor_minerals = {
	{"malachite", "Malachite"},
	{"cinnabar", "Cinnabar"},
	{"gypsum", "Gypsum"},
	{"jet", "Jet"},
	{"lazurite", "Lazurite"},
	{"olivine", "Olivine"},
	{"petrified_wood", "Petrified Wood"},
	{"satinspar", "Satinspar"},
	{"selenite", "Selenite"},
	{"serpentine", "Serpentine"}
}

for _, mineral in ipairs(decor_minerals) do
	minetest.register_node("decorations:"..mineral[1].."_block", {
		description = mineral[2].." Block",
		tiles = {"decorations_"..mineral[1]..".png"},
		particle_image = {"minerals_"..mineral[1]..".png"},
		drop = "minerals:"..mineral[1].." 4",
		groups = {cracky=3,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_node("decorations:"..mineral[1].."_pyramid", {
		description = mineral[2].." Pyramid",
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
		tiles = {"decorations_"..mineral[1]..".png"},
		particle_image = {"minerals_"..mineral[1]..".png"},
		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults(),
	})
	
	for i, tree_name in ipairs(realtest.registered_trees_list) do
		local tree = realtest.registered_trees[tree_name]
		minetest.register_node("decorations:"..mineral[1].."_table_"..i, {
			description = mineral[2].." Table",
			drawtype = "nodebox",
			paramtype = "light",
			node_box = {
					type = "fixed",
					fixed = {
						{-0.5, 0.3075, -0.5, 0.5, 0.5, 0.5},
						{-0.4375, -0.5, -0.4375, -0.25, 0.3125, -0.25},
						{-0.4375, -0.5, 0.25, -0.25, 0.3125, 0.4375},
						{0.25, -0.5, -0.4375, 0.4375, 0.3125, -0.25},
						{0.25, -0.5, 0.25, 0.4375, 0.3125, 0.4375},
					},
				},
			selection_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
					},
				},
			tiles = {"decorations_"..mineral[1]..".png", tree.textures.planks.."^decorations_"..mineral[1].."_table_bottom.png",
				tree.textures.planks.."^decorations_"..mineral[1].."_table_side.png"},
			groups = {cracky=3, oddly_breakable_by_hand = 2},
			sounds = default.node_sound_stone_defaults(),
		})
		minetest.register_craft({
			output = "decorations:"..mineral[1].."_table_"..i,
			recipe = {
				{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
				{tree.name.."_plank","",tree.name.."_plank"},
				{tree.name.."_plank","",tree.name.."_plank"},
			}
		})
	end
	
	minetest.register_node("decorations:"..mineral[1].."_casket", {
		description = mineral[2].." Casket",
		drawtype = "nodebox",
		tiles = {"decorations_"..mineral[1].."_casket_top.png", "decorations_"..mineral[1].."_casket_top.png", "decorations_"..mineral[1].."_casket_side.png",
			"decorations_"..mineral[1].."_casket_side.png", "decorations_"..mineral[1].."_casket_side.png", "decorations_"..mineral[1].."_casket_front.png"},
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
					"list[current_name;main;1,0.5;6,3;]"..
					"list[current_player;main;0,4;8,4;]")
			meta:set_string("infotext", mineral[2].." Casket")
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("main")
		end,
	})
	
	minetest.register_node("decorations:"..mineral[1].."_chest", {
		description = mineral[2].." Chest",
		tiles = {"decorations_"..mineral[1].."_chest_top.png", "decorations_"..mineral[1].."_chest_top.png", "decorations_"..mineral[1].."_chest_side.png",
			"decorations_"..mineral[1].."_chest_side.png", "decorations_"..mineral[1].."_chest_side.png", "decorations_"..mineral[1].."_chest_front.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec",
					"size[8,9]"..
					"list[current_name;main;0,0;8,4;]"..
					"list[current_player;main;0,5;8,4;]")
			meta:set_string("infotext", mineral[2].." Chest")
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("main")
		end,
	})
	
	local function has_locked_chest_privilege(meta, player)
		if player:get_player_name() ~= meta:get_string("owner") then
			return false
		end
		return true
	end
	
	minetest.register_node("decorations:"..mineral[1].."_chest_locked", {
		description = mineral[2].." Locked Chest",
		tiles = {"decorations_"..mineral[1].."_chest_top.png", "decorations_"..mineral[1].."_chest_top.png", "decorations_"..mineral[1].."_chest_side.png",
			"decorations_"..mineral[1].."_chest_side.png", "decorations_"..mineral[1].."_chest_side.png", "decorations_"..mineral[1].."_chest_lock.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_wood_defaults(),
		after_place_node = function(pos, placer)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("infotext", mineral[2].." Locked Chest (owned by "..
					meta:get_string("owner")..")")
		end,
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", mineral[2].." Locked Chest")
			meta:set_string("owner", "")
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("main") and player:get_player_name() == meta:get_string("owner")
		end,
		allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			local meta = minetest.env:get_meta(pos)
			if not has_locked_chest_privilege(meta, player) then
				minetest.log("action", player:get_player_name()..
						" tried to access a locked chest belonging to "..
						meta:get_string("owner").." at "..
						minetest.pos_to_string(pos))
				return 0
			end
			return count
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			local meta = minetest.env:get_meta(pos)
			if not has_locked_chest_privilege(meta, player) then
				minetest.log("action", player:get_player_name()..
						" tried to access a locked chest belonging to "..
						meta:get_string("owner").." at "..
						minetest.pos_to_string(pos))
				return 0
			end
			return stack:get_count()
		end,
		allow_metadata_inventory_take = function(pos, listname, index, stack, player)
			local meta = minetest.env:get_meta(pos)
			if not has_locked_chest_privilege(meta, player) then
				minetest.log("action", player:get_player_name()..
						" tried to access a locked chest belonging to "..
						meta:get_string("owner").." at "..
						minetest.pos_to_string(pos))
				return 0
			end
			return stack:get_count()
		end,
		on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			minetest.log("action", player:get_player_name()..
					" moves stuff in locked chest at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name()..
					" moves stuff to locked chest at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name()..
					" takes stuff from locked chest at "..minetest.pos_to_string(pos))
			end,
		on_rightclick = function(pos, node, clicker)
			local meta = minetest.env:get_meta(pos)
			if has_locked_chest_privilege(meta, clicker) then
				local pos = pos.x .. "," .. pos.y .. "," ..pos.z
				minetest.show_formspec(clicker:get_player_name(),
					"decorations:locked_chest",
					"size[8,9]"..
					"list[nodemeta:".. pos .. ";main;0,0;8,4;]"..
					"list[current_player;main;0,5;8,4;]")
			end
		end,
	})
	
	minetest.register_node("decorations:"..mineral[1].."_cylinder", {
		description = mineral[2].." Cylinder",
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
		tiles = {"decorations_"..mineral[1]..".png"},
		particle_image = {"minerals_"..mineral[1]..".png"},
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_node("decorations:"..mineral[1].."_vase", {
		description = mineral[2].." Vase",
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
		tiles = {"decorations_"..mineral[1]..".png"},
		groups = {cracky=3, oddly_breakable_by_hand = 2},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_node("decorations:"..mineral[1].."_vase_with_coals", {
		description = mineral[2].." Vase With Coals",
		drawtype = "nodebox",
		paramtype = "light",
		light_source = 14,
		node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.35, -0.5, -0.4, 0, 0.5},
					{-0.5, -0.35, 0.4, 0.5, 0, 0.5},
					{-0.5, -0.35, -0.5, 0.5, 0, -0.4},
					{0.4,  -0.35, -0.5, 0.5, 0, 0.5},
					{-0.4, -0.5, -0.4, 0.4, -0.1, 0.4},
				},
			},
		tiles = {
			{name="decorations_"..mineral[1].."_coals.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},"decorations_"..mineral[1].."_coals.png", "decorations_"..mineral[1]..".png"
		},
		groups = {cracky=3, oddly_breakable_by_hand = 2},
		sounds = default.node_sound_stone_defaults(),
	})
	
	
	
	minetest.register_craft({
		output = "decorations:"..mineral[1].."_casket",
		recipe = {
			{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
			{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
		}
	})

	minetest.register_craft({
		output = "decorations:"..mineral[1].."_chest 2",
		recipe = {
			{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
			{"minerals:"..mineral[1],"","minerals:"..mineral[1]},
			{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
		}
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "decorations:"..mineral[1].."_chest_locked",
		recipe = {"group:lock","decorations:"..mineral[1].."_chest"}
	})

	minetest.register_craft({
		output = "decorations:"..mineral[1].."_block",
		recipe = {
			{"minerals:"..mineral[1],"minerals:"..mineral[1]},
			{"minerals:"..mineral[1],"minerals:"..mineral[1]},
		}
	})

	realtest.register_stair("decorations:"..mineral[1].."_block",mineral[2].." Stair",nil,nil,nil,nil,"minerals:"..mineral[1].." 3")
	realtest.register_slab("decorations:"..mineral[1].."_block",mineral[2].." Slab",nil,nil,nil,nil,"minerals:"..mineral[1].." 2")

	minetest.register_craft({
		output = "decorations:"..mineral[1].."_block_slab",
		recipe = {
			{"minerals:"..mineral[1],"minerals:"..mineral[1]},
		},
	})
	minetest.register_craft({
		output = "decorations:"..mineral[1].."_block_stair",
		recipe = {
			{"minerals:"..mineral[1],""},
			{"minerals:"..mineral[1],"minerals:"..mineral[1]},
		},
	})
	minetest.register_craft({
		output = "decorations:"..mineral[1].."_block_stair",
		recipe = {
			{"","minerals:"..mineral[1]},
			{"minerals:"..mineral[1],"minerals:"..mineral[1]},
		},
	})

	minetest.register_craft({
		output = "decorations:"..mineral[1].."_pyramid",
		recipe = {
			{"","minerals:"..mineral[1],""},
			{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
		}
	})

	minetest.register_craft({
		output = "decorations:"..mineral[1].."_cylinder",
		recipe = {
			{"","minerals:"..mineral[1],""},
			{"minerals:"..mineral[1],"minerals:"..mineral[1],"minerals:"..mineral[1]},
			{"","minerals:"..mineral[1],""},
		}
	})

	minetest.register_craft({
		output = "decorations:"..mineral[1].."_vase",
		recipe = {
			{"minerals:"..mineral[1],"","minerals:"..mineral[1]},
			{"","minerals:"..mineral[1],""},
			{"","minerals:"..mineral[1],""},
		}
	})
end

for i, tree_name in ipairs(realtest.registered_trees_list) do
	local tree = realtest.registered_trees[tree_name]
	minetest.register_node("decorations:bookshelf_"..tree.name:remove_modname_prefix(), {
		description = tree.description.." Bookshelf",
		tiles = {tree.textures.planks, tree.textures.planks, tree.textures.planks.."^decorations_bookshelf.png"},
		groups = {bookshelf=1,snappy=2,choppy=3,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
	})
	minetest.register_craft({
		output = "decorations:bookshelf_"..tree.name:remove_modname_prefix(),
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{"default:book", "default:book", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		}
	})
end