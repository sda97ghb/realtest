realtest.registered_trees = {}
realtest.registered_trees_list = {}
function realtest.register_tree(name, TreeDef)
	if not TreeDef.textures then
		return
	end
	local tree = {
		name = name,
		description = TreeDef.description or "",
		grounds = TreeDef.grounds or {"default:dirt","default:dirt_with_grass"},
		leaves = TreeDef.leaves or {},
		height = TreeDef.height or function() return 10 end,
		radius = TreeDef.radius or 5,
		textures = TreeDef.textures or {},
		grow_interval = TreeDef.grow_interval or 60,
		grow_chance = TreeDef.grow_chance or 20,
		grow_light = TreeDef.grow_light or 8
	}
	realtest.registered_trees[name] = tree
	table.insert(realtest.registered_trees_list, tree.name)
	
	minetest.register_node(tree.name.."_planks", {
		description = tree.description.." Planks",
		tiles = {tree.textures.planks},
		groups = {planks=1,snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_craftitem(tree.name.."_stick", {
		description = tree.description.." Stick",
		inventory_image = tree.textures.stick,
		groups = {stick=1},
	})
	
	minetest.register_node(tree.name.."_sapling", {
		description = tree.description.." Sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles = {tree.textures.sapling},
		inventory_image = tree.textures.sapling,
		wield_image = tree.textures.sapling,
		paramtype = "light",
		walkable = false,
		groups = {snappy=2,dig_immediate=3,flammable=2,dropping_node=1},
		sounds = default.node_sound_defaults(),
	})
	
	minetest.register_craftitem(tree.name.."_plank", {
		description = tree.description.." Plank",
		inventory_image = tree.textures.plank,
		group = {plank=1},
	})
	
	minetest.register_node(tree.name.."_log", {
		description = tree.description.." Log",
		tiles = tree.textures.trunk,
		inventory_image = tree.textures.log,
		wield_image = tree.textures.log,
		groups = {log=1,snappy=1,choppy=2,flammable=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = tree.name.."_plank 4",
		drop_on_dropping = tree.name.."_log",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
	})
	
	minetest.register_node(tree.name.."_leaves", {
		description = tree.description.." Leaves",
		drawtype = "allfaces_optional",
		visual_scale = 1.3,
		tiles = {tree.textures.leaves},
		paramtype = "light",
		groups = {snappy=3, leafdecay=3, flammable=2,drop_on_dig=1,leaves=1},
		drop = {
			max_items = 1,
			items = {
				{
					items = {tree.name..'_sapling'},
					rarity = 30,
				},
				{
					items = {tree.name..'_stick'},
					rarity = 10,
				},
				{
					items = {},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		walkable = false,
		climbable = true,
	})
	
	if tree.textures.autumn_leaves then
		minetest.register_node(tree.name.."_leaves_autumn", {
			description = tree.description.." Leaves",
			drawtype = "allfaces_optional",
			visual_scale = 1.3,
			tiles = {tree.textures.autumn_leaves},
			paramtype = "light",
			groups = {snappy=3, leafdecay=3, flammable=2,drop_on_dig=1,leaves=1},
			drop = {
				max_items = 1,
				items = {
					{
						items = {tree.name..'_sapling'},
						rarity = 30,
					},
					{
						items = {tree.name..'_stick'},
						rarity = 10,
					},
					{
						items = {},
					}
				}
			},
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			climbable = true,
		})
	end
	
	if tree.textures.winter_leaves then
		minetest.register_node(tree.name.."_leaves_winter", {
			description = tree.description.." Leaves",
			drawtype = "allfaces_optional",
			visual_scale = 1.3,
			tiles = {tree.textures.autumn_leaves},
			paramtype = "light",
			groups = {snappy=3, leafdecay=3, flammable=2,drop_on_dig=1,leaves=1},
			drop = {
				max_items = 1,
				items = {
					{
						items = {tree.name..'_stick'},
						rarity = 10,
					},
					{
						items = {},
					}
				}
			},
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			climbable = true,
		})
	end
	
	minetest.register_node(tree.name.."_trunk", {
		description = tree.description.." Trunk",
		tiles = tree.textures.trunk,
		groups = {tree=1,snappy=1,choppy=2,flammable=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = tree.name.."_log",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
	})
	
	minetest.register_node(tree.name.."_trunk_top", {
		tiles = tree.textures.trunk,
		groups = {tree=1,snappy=1,choppy=2,flammable=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_wood_defaults(),
		drop = tree.name.."_log",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4,0.4,0.5,0.4},
			},
		},
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			for i = 1,#tree.leaves do
				local p = {x=pos.x+tree.leaves[i][1], y=pos.y+tree.leaves[i][2], z=pos.z+tree.leaves[i][3]}
				if minetest.env:get_node(p).name == tree.name.."_leaves" then
					minetest.env:dig_node(p)
				end
			end
		end,
	})

	minetest.register_node(tree.name.."_ladder", {
		description = tree.description.." Ladder",
		drawtype = "nodebox",
		tiles = {tree.textures.planks},
		particle_image = {tree.textures.planks},
		inventory_image = tree.textures.ladder,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		climbable = true,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0.5-1/7, -0.5+1/7, 0.5, 0.5},
				{0.5-1/7, -0.5, 0.5-1/7, 0.5, 0.5, 0.5},
				{-0.5+1/7, 0.5-1/6-1/12, 0.5-1/16, 0.5-1/7, 0.5-1/12, 0.5},
				{-0.5+1/7, 0.5-1/12-1/6*3, 0.5-1/16, 0.5-1/7, 0.5-1/12-1/6*2, 0.5},
				{-0.5+1/7, 0.5-1/12-1/6*5, 0.5-1/16, 0.5-1/7, 0.5-1/12-1/6*4, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0.5-1/7, -0.5+1/7, 0.5, 0.5},
				{0.5-1/7, -0.5, 0.5-1/7, 0.5, 0.5, 0.5},
				{-0.5+1/7, 0.5-1/6-1/12, 0.5-1/16, 0.5-1/7, 0.5-1/12, 0.5},
				{-0.5+1/7, 0.5-1/12-1/6*3, 0.5-1/16, 0.5-1/7, 0.5-1/12-1/6*2, 0.5},
				{-0.5+1/7, 0.5-1/12-1/6*5, 0.5-1/16, 0.5-1/7, 0.5-1/12-1/6*4, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type == "node" and
				minetest.registered_nodes[minetest.env:get_node(pointed_thing.above).name].buildable_to == true then
				local param2 = nil
				if pointed_thing.above.x < pointed_thing.under.x then
					param2 = 1
				elseif pointed_thing.above.x > pointed_thing.under.x then
					param2 = 3
				elseif pointed_thing.above.z < pointed_thing.under.z then
					param2 = 0
				elseif pointed_thing.above.z > pointed_thing.under.z then
					param2 = 2
				end
				if param2 then
					minetest.env:set_node(pointed_thing.above,{name = tree.name.."_ladder", param2 = param2})
					itemstack:take_item()
				end
				return itemstack
			end
		end,
		node_placement_prediction = "",
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=3,flammable=2},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_node(tree.name.."_chest", {
		description =  tree.description.." Chest",
		tiles = tree.textures.chest,
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec",
					"size[8,9]"..
					"list[current_name;main;0,0;8,4;]"..
					"list[current_player;main;0,5;8,4;]")
			meta:set_string("infotext", tree.description.." Chest")
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
	
	minetest.register_node(tree.name.."_chest_locked", {
		description = tree.description.." Locked Chest",
		tiles = tree.textures.locked_chest,
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_wood_defaults(),
		after_place_node = function(pos, placer)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("infotext", tree.description.." Locked Chest (owned by "..
					meta:get_string("owner")..")")
		end,
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec",
					"size[8,9]"..
					"list[current_name;main;0,0;8,4;]"..
					"list[current_player;main;0,5;8,4;]")
			meta:set_string("infotext", tree.description.." Locked Chest")
			meta:set_string("owner", "")
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("main")
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
	})
	
	minetest.register_craft({
		output = tree.name.."_ladder",
		recipe = {
			{tree.name.."_stick", "", tree.name.."_stick"},
			{tree.name.."_stick", tree.name.."_stick", tree.name.."_stick"},
			{tree.name.."_stick", "", tree.name.."_stick"},
		}
	})
	
	minetest.register_craft({
		output = tree.name.."_chest",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", "", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		},
	})
	
	for i,metal in ipairs(metals.list) do
		minetest.register_craft({
			output = tree.name.."_chest_locked",
			recipe = {
				{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
				{tree.name.."_plank", "metals:"..metal.."_lock", tree.name.."_plank"},
				{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			}
		})
	end
	
	realtest.register_stair(tree.name.."_planks",nil,nil,nil,tree.description.." Stair")
	realtest.register_slab(tree.name.."_planks",nil,nil,nil,tree.description.." Slab")
	minetest.register_craft({
		output = tree.name.."_planks_slab",
		recipe = {
			{tree.name.."_plank",tree.name.."_plank"},
		},
	})
	minetest.register_craft({
		output = tree.name.."_planks_stair",
		recipe = {
			{tree.name.."_plank",""},
			{tree.name.."_plank",tree.name.."_plank"},
		},
	})
	minetest.register_craft({
		output = tree.name.."_planks_stair",
		recipe = {
			{"",tree.name.."_plank"},
			{tree.name.."_plank",tree.name.."_plank"},
		},
	})
	minetest.register_craft({
		output = tree.name.."_plank 3",
		recipe = {{tree.name.."_planks_stair"}}
	})
	minetest.register_craft({
		output = tree.name.."_plank 2",
		recipe = {{tree.name.."_planks_slab"}}
	})
	
	minetest.register_craft({
		output = "default:sign_wall",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{"", "group:stick", ""},
		}
	})
	
	minetest.register_craft({
		output = tree.name.."_planks",
		recipe = {
			{tree.name.."_plank",tree.name.."_plank"},
			{tree.name.."_plank",tree.name.."_plank"}
		}
	})
	
	minetest.register_craft({
		output = tree.name.."_plank 4",
		recipe = {{tree.name.."_planks"}}
	})
	
	minetest.register_craft({
		type = "fuel",
		recipe = "default:chest",
		burntime = 40,
	})
	
	minetest.register_craft({
		type = "fuel",
		recipe = "default:chest_locked",
		burntime = 40,
	})
	
	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_stair",
		burntime = 3.5,
	})
	realtest.add_bonfire_fuel(tree.name.."_stair")
	
	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_slab",
		burntime = 3.5,
	})
	realtest.add_bonfire_fuel(tree.name.."_slab")
	
	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_plank",
		burntime = 2,
	})
	realtest.add_bonfire_fuel(tree.name.."_plank")

	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_planks",
		burntime = 7,
	})
	realtest.add_bonfire_fuel(tree.name.."_planks")

	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_log",
		burntime = 7,
	})
	realtest.add_bonfire_fuel(tree.name.."_log")
	
	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_stick",
		burntime = 1,
	})
	realtest.add_bonfire_fuel(tree.name.."_stick")
	
	minetest.register_craft({
		type = "fuel",
		recipe = tree.name.."_sapling",
		burntime = 5,
	})
	realtest.add_bonfire_fuel(tree.name.."_sapling")
	
	minetest.register_craft({
		type="cooking",
		output="default:coal_lump",
		recipe=tree.name.."_log",
	})
	
	minetest.register_abm({
		nodenames = {tree.name.."_sapling"},
		neighbors = tree.grounds,
		interval = tree.grow_interval,
		chance = tree.grow_chance,
		action = function(pos, node)
			if not minetest.env:get_node_light(pos) then
				return
			end
			if minetest.env:get_node_light(pos) >= tree.grow_light then
				trees.make_tree(pos, tree.name)
			end
		end,
	})
end

minetest.after(0, function()
	if #realtest.registered_trees_list > 0 then
		minetest.register_alias("default:chest", realtest.registered_trees_list[1].."_chest")
		minetest.register_alias("default:chest_locked", realtest.registered_trees_list[1].."_chest_locked")
	end
end)

realtest.register_tree("trees:ash", {
	description = "Ash",
	leaves = trees.gen_lists.ash,
	height = function()
		return 4 + math.random(4)
	end,
	textures = {
		trunk = {"trees_ash_trunk_top.png", "trees_ash_trunk_top.png", "trees_ash_trunk.png"},
		leaves = "trees_ash_leaves.png",
		autumn_leaves = "trees_ash_autumn_leaves.png",
		planks = "trees_ash_planks.png",
		stick = "trees_ash_stick.png",
		sapling = "trees_ash_sapling.png",
		log = "trees_ash_log.png",
		plank = "trees_ash_plank.png",
		ladder = "trees_ash_ladder.png",
		door_inventory = "trees_ash_door_inventory.png",
		door_top = "trees_ash_door_top.png",
		door_bottom = "trees_ash_door_bottom.png",
		chest = {"trees_ash_chest_top.png", "trees_ash_chest_top.png", "trees_ash_chest_side.png",
				"trees_ash_chest_side.png", "trees_ash_chest_side.png", "trees_ash_chest_front.png"},
		locked_chest = {"trees_ash_chest_top.png", "trees_ash_chest_top.png", "trees_ash_chest_side.png",
			"trees_ash_chest_side.png", "trees_ash_chest_side.png", "trees_ash_chest_lock.png"},
	}
})
realtest.register_tree("trees:aspen", {
	description = "Aspen",
	leaves = trees.gen_lists.aspen,
	height = function()
		return 10 + math.random(4)
	end,
	textures = {
		trunk = {"trees_aspen_trunk_top.png", "trees_aspen_trunk_top.png", "trees_aspen_trunk.png"},
		leaves = "trees_aspen_leaves.png",
		planks = "trees_aspen_planks.png",
		stick = "trees_aspen_stick.png",
		sapling = "trees_aspen_sapling.png",
		log = "trees_aspen_log.png",
		plank = "trees_aspen_plank.png",
		ladder = "trees_aspen_ladder.png",
		door_inventory = "trees_aspen_door_inventory.png",
		door_top = "trees_aspen_door_top.png",
		door_bottom = "trees_aspen_door_bottom.png",
		chest = {"trees_aspen_chest_top.png", "trees_aspen_chest_top.png", "trees_aspen_chest_side.png",
				"trees_aspen_chest_side.png", "trees_aspen_chest_side.png", "trees_aspen_chest_front.png"},
		locked_chest = {"trees_aspen_chest_top.png", "trees_aspen_chest_top.png", "trees_aspen_chest_side.png",
			"trees_aspen_chest_side.png", "trees_aspen_chest_side.png", "trees_aspen_chest_lock.png"},
	}
})
realtest.register_tree("trees:birch", {
	description = "Birch",
	leaves = trees.gen_lists.birch,
	height = function()
		return 10 + math.random(4)
	end,
	textures = {
		trunk = {"trees_birch_trunk_top.png", "trees_birch_trunk_top.png", "trees_birch_trunk.png"},
		leaves = "trees_birch_leaves.png",
		planks = "trees_birch_planks.png",
		stick = "trees_birch_stick.png",
		sapling = "trees_birch_sapling.png",
		log = "trees_birch_log.png",
		plank = "trees_birch_plank.png",
		ladder = "trees_birch_ladder.png",
		door_inventory = "trees_birch_door_inventory.png",
		door_top = "trees_birch_door_top.png",
		door_bottom = "trees_birch_door_bottom.png",
		chest = {"trees_birch_chest_top.png", "trees_birch_chest_top.png", "trees_birch_chest_side.png",
				"trees_birch_chest_side.png", "trees_birch_chest_side.png", "trees_birch_chest_front.png"},
		locked_chest = {"trees_birch_chest_top.png", "trees_birch_chest_top.png", "trees_birch_chest_side.png",
			"trees_birch_chest_side.png", "trees_birch_chest_side.png", "trees_birch_chest_lock.png"},
	}
})
realtest.register_tree("trees:mapple", {
	description = "Mapple",
	leaves = trees.gen_lists.mapple,
	height = function()
		return 7 + math.random(5)
	end,
	textures = {
		trunk = {"trees_mapple_trunk_top.png", "trees_mapple_trunk_top.png", "trees_mapple_trunk.png"},
		leaves = "trees_mapple_leaves.png",
		planks = "trees_mapple_planks.png",
		stick = "trees_mapple_stick.png",
		sapling = "trees_mapple_sapling.png",
		log = "trees_mapple_log.png",
		plank = "trees_mapple_plank.png",
		ladder = "trees_mapple_ladder.png",
		door_inventory = "trees_mapple_door_inventory.png",
		door_top = "trees_mapple_door_top.png",
		door_bottom = "trees_mapple_door_bottom.png",
		chest = {"trees_mapple_chest_top.png", "trees_mapple_chest_top.png", "trees_mapple_chest_side.png",
				"trees_mapple_chest_side.png", "trees_mapple_chest_side.png", "trees_mapple_chest_front.png"},
		locked_chest = {"trees_mapple_chest_top.png", "trees_mapple_chest_top.png", "trees_mapple_chest_side.png",
			"trees_mapple_chest_side.png", "trees_mapple_chest_side.png", "trees_mapple_chest_lock.png"},
	}
})
realtest.register_tree("trees:chestnut", {
	description = "Chestnut",
	leaves = trees.gen_lists.chestnut,
	height = function()
		return 9 + math.random(2)
	end,
	radius = 10,
	textures = {
		trunk = {"trees_chestnut_trunk_top.png", "trees_chestnut_trunk_top.png", "trees_chestnut_trunk.png"},
		leaves = "trees_chestnut_leaves.png",
		planks = "trees_chestnut_planks.png",
		stick = "trees_chestnut_stick.png",
		sapling = "trees_chestnut_sapling.png",
		log = "trees_chestnut_log.png",
		plank = "trees_chestnut_plank.png",
		ladder = "trees_chestnut_ladder.png",
		door_inventory = "trees_chestnut_door_inventory.png",
		door_top = "trees_chestnut_door_top.png",
		door_bottom = "trees_chestnut_door_bottom.png",
		chest = {"trees_chestnut_chest_top.png", "trees_chestnut_chest_top.png", "trees_chestnut_chest_side.png",
				"trees_chestnut_chest_side.png", "trees_chestnut_chest_side.png", "trees_chestnut_chest_front.png"},
		locked_chest = {"trees_chestnut_chest_top.png", "trees_chestnut_chest_top.png", "trees_chestnut_chest_side.png",
			"trees_chestnut_chest_side.png", "trees_chestnut_chest_side.png", "trees_chestnut_chest_lock.png"},
	}
})
realtest.register_tree("trees:pine", {
	description = "Pine",
	leaves = trees.gen_lists.pine,
	height = function()
		return 13 + math.random(4)
	end,
	radius = 8,
	textures = {
		trunk = {"trees_pine_trunk_top.png", "trees_pine_trunk_top.png", "trees_pine_trunk.png"},
		leaves = "trees_pine_leaves.png",
		planks = "trees_pine_planks.png",
		stick = "trees_pine_stick.png",
		sapling = "trees_pine_sapling.png",
		log = "trees_pine_log.png",
		plank = "trees_pine_plank.png",
		ladder = "trees_pine_ladder.png",
		door_inventory = "trees_pine_door_inventory.png",
		door_top = "trees_pine_door_top.png",
		door_bottom = "trees_pine_door_bottom.png",
		chest = {"trees_pine_chest_top.png", "trees_pine_chest_top.png", "trees_pine_chest_side.png",
				"trees_pine_chest_side.png", "trees_pine_chest_side.png", "trees_pine_chest_front.png"},
		locked_chest = {"trees_pine_chest_top.png", "trees_pine_chest_top.png", "trees_pine_chest_side.png",
			"trees_pine_chest_side.png", "trees_pine_chest_side.png", "trees_pine_chest_lock.png"},
	}
})