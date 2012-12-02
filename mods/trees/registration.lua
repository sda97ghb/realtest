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
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			for i = 1,#tree.leaves do
				local p = {x=pos.x+tree.leaves[i][1], y=pos.y+tree.leaves[i][2], z=pos.z+tree.leaves[i][3]}
				if minetest.env:get_node(p).name == tree.name.."_leaves" then
					minetest.env:dig_node(p)
				end
			end
		end,
	})
	
	minetest.register_node(tree.name.."_fence", {
		description = tree.description.." Fence",
		drawtype = "fencelike",
		tiles = {tree.textures.planks},
		paramtype = "light",
		is_ground_content = true,
		selection_box = {
			type = "fixed",
			fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
		},
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_node(tree.name.."_stair", {
		description = tree.description.." Stair",
		drawtype = "nodebox",
		tiles = {tree.textures.planks},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
	})
	
	minetest.register_node(tree.name.."_slab", {
		description = tree.description.." Slab",
		drawtype = "nodebox",
		tiles = {tree.textures.planks},
		paramtype = "light",
		is_ground_content = true,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2},
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
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
				end
				itemstack:take_item()
				return itemstack
			end
		end,
		node_placement_prediction = "",
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=3,flammable=2},
		sounds = default.node_sound_wood_defaults(),
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
		output = tree.name.."_slab",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		},
	})
	
	minetest.register_craft({
		output = tree.name.."_planks",
		recipe = {
			{tree.name.."_slab"},
			{tree.name.."_slab"},
		},
	})
	
	minetest.register_craft({
		output = tree.name.."_stair 2",
		recipe = {
			{tree.name.."_plank", "", ""},
			{tree.name.."_plank", tree.name.."_plank", ""},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		},
	})
	
	minetest.register_craft({
		output = tree.name.."_stair 2",
		recipe = {
			{"", "", tree.name.."_plank"},
			{"", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		},
	})
	
	minetest.register_craft({
		output = tree.name.."_fence 2",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		}
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
		output = "default:chest",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", "", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		}
	})

	for i,metal in ipairs(metals.list) do
		minetest.register_craft({
			output = "default:chest_locked",
			recipe = {
				{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
				{tree.name.."_plank", "metals:"..metal.."_lock", tree.name.."_plank"},
				{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			}
		})
	end
	
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
		ladder = "trees_ash_ladder.png"
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
		ladder = "trees_aspen_ladder.png"
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
		ladder = "trees_birch_ladder.png"
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
		ladder = "trees_mapple_ladder.png"
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
		ladder = "trees_chestnut_ladder.png"
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
		ladder = "trees_pine_ladder.png"
	}
})
