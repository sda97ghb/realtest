realtest.registered_trees = {}
realtest.registered_trees_list = {}
function realtest.register_tree(name, TreeDef)
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
		grow_light = TreeDef.grow_light or 8,
		gen_autumn_leaves = false,
		gen_winter_leaves = false,
	}
	if TreeDef.gen_autumn_leaves then
		tree.gen_autumn_leaves = true
	end
	if TreeDef.gen_winter_leaves then
		tree.gen_winter_leaves = true
	end
	local name_ = name:get_modname_prefix().."_"..name:remove_modname_prefix()
	tree.textures.trunk = tree.textures.trunk or {name_.."_trunk_top.png", name_.."_trunk_top.png", name_.."_trunk.png"}
	tree.textures.leaves = tree.textures.leaves or name_.."_leaves.png"
	tree.textures.autumn_leaves = tree.textures.autumn_leaves or name_.."_autumn_leaves.png"
	tree.textures.winter_leaves = tree.textures.winter_leaves or name_.."_winter_leaves.png"
	tree.textures.planks = tree.textures.planks or name_.."_planks.png"
	tree.textures.stick = tree.textures.stick or name_.."_stick.png"
	tree.textures.sapling = tree.textures.sapling or name_.."_sapling.png"
	tree.textures.log = tree.textures.log or name_.."_log.png"
	tree.textures.plank = tree.textures.plank or name_.."_plank.png"
	tree.textures.ladder = tree.textures.ladder or name_.."_ladder.png"
	tree.textures.door_inventory = tree.textures.door_inventory or name_.."_door_inventory.png"
	tree.textures.door_top = tree.textures.door_top or name_.."_door_top.png"
	tree.textures.door_bottom = tree.textures.door_bottom or name_.."_door_bottom.png"
	tree.textures.chest = tree.textures.chest or {name_.."_chest_top.png", name_.."_chest_top.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_front.png"}
	tree.textures.locked_chest = tree.textures.locked_chest or {name_.."_chest_top.png", name_.."_chest_top.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_side.png", name_.."_chest_lock.png"}

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
		falling_node_walkable = false,
		groups = {snappy=2,dig_immediate=3,flammable=2,dropping_node=1},
		sounds = default.node_sound_defaults()
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
		groups = {log=1,immediately_breakable_by_hand=2,snappy=1,choppy=2,flammable=2,dropping_node=1,drop_on_dig=1},
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
		on_dig = function(pos, node, digger)
			minetest.debug("node_dig")

			local def = ItemStack({name=node.name}):get_definition()
			-- Check if def ~= 0 because we always want to be able to remove unknown nodes
			if #def ~= 0 and not def.diggable or (def.can_dig and not def.can_dig(pos,digger)) and digger:get_wielded_item():get_name() ~= ":" then
				minetest.debug("not diggable")
				minetest.log("info", digger:get_player_name() .. " tried to dig "
					.. node.name .. " which is not diggable "
					.. minetest.pos_to_string(pos))
				return
			end

			minetest.log('action', digger:get_player_name() .. " digs "
				.. node.name .. " at " .. minetest.pos_to_string(pos))

			local wielded = digger:get_wielded_item()
			local drops = {}
			if string.find(wielded:get_name(), "instruments:saw_") then
				drops = {tree.name.."_plank 8"}
			elseif string.find(wielded:get_name(), "instruments:axe_") then
				drops = {tree.name.."_plank 4"}
			else
				drops = {tree.name.."_log"}
			end

			-- Wear out tool
			local tp = wielded:get_tool_capabilities()
			local dp = minetest.get_dig_params(def.groups, tp)
			wielded:add_wear(dp.wear)
			digger:set_wielded_item(wielded)
			
			-- Handle drops
			minetest.handle_node_drops(pos, drops, digger)

			local oldmetadata = nil
			if def.after_dig_node then
				oldmetadata = minetest.env:get_meta(pos):to_table()
			end

			-- Remove node and update
			minetest.env:remove_node(pos)
			
			-- Run callback
			if def.after_dig_node then
				-- Copy pos and node because callback can modify them
				local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
				local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
				def.after_dig_node(pos_copy, node_copy, oldmetadata, digger)
			end

			-- Run script hook
			local _, callback
			for _, callback in ipairs(minetest.registered_on_dignodes) do
				-- Copy pos and node because callback can modify them
				local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
				local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
				callback(pos_copy, node_copy, digger)
			end
		end,
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
		falling_node_walkable = false,
		climbable = true,
	})
	
	if tree.gen_autumn_leaves then
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
			falling_node_walkable = false,
			climbable = true,
		})
	end
	
	if tree.gen_winter_leaves then
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
			falling_node_walkable = false,
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
					if not minetest.setting_getbool("creative_mode") then
						itemstack:take_item()
					end
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
			meta:set_string("infotext", tree.description.." Locked Chest")
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
					"trees:locked_chest",
					"size[8,9]"..
					"list[nodemeta:".. pos .. ";main;0,0;8,4;]"..
					"list[current_player;main;0,5;8,4;]")
			end
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
		output = tree.name.."_chest 2",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", "", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		},
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = tree.name.."_chest_locked",
		recipe = {"group:lock", tree.name.."_chest"}
	})
	
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
		output="minerals:charcoal",
		recipe=tree.name.."_log",
	})
	
	minetest.register_craft({
		type = "cooking",
		output = "default:torch 2",
		recipe = tree.name.."_stick"
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

realtest.register_tree("trees:ash", {
	description = "Ash",
	leaves = trees.gen_lists.ash,
	height = function()
		return 4 + math.random(4)
	end,
})
realtest.register_tree("trees:aspen", {
	description = "Aspen",
	leaves = trees.gen_lists.aspen,
	height = function()
		return 10 + math.random(4)
	end,
})
realtest.register_tree("trees:birch", {
	description = "Birch",
	leaves = trees.gen_lists.birch,
	height = function()
		return 10 + math.random(4)
	end,
})
realtest.register_tree("trees:maple", {
	description = "Maple",
	leaves = trees.gen_lists.maple,
	height = function()
		return 7 + math.random(5)
	end,
})
realtest.register_tree("trees:chestnut", {
	description = "Chestnut",
	leaves = trees.gen_lists.chestnut,
	height = function()
		return 9 + math.random(2)
	end,
	radius = 10,
})
realtest.register_tree("trees:pine", {
	description = "Pine",
	leaves = trees.gen_lists.pine,
	height = function()
		return 13 + math.random(4)
	end,
	radius = 8,
})
realtest.register_tree("trees:spruce", {
	description = "Spruce",
	leaves = trees.gen_lists.spruce,
	height = function()
		return 10 + math.random(4)
	end,
})