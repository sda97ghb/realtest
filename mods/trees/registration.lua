realtest.registered_trees = {}
function realtest.register_tree(name, TreeDef)
	local tree = {
		name = name,
		description = TreeDef.description or "",
		grounds = TreeDef.grounds or {"default:dirt","default:dirt_with_grass"},
		leaves = TreeDef.leaves or {},
		height = TreeDef.height or function() return 10 end,
		radius = TreeDef.radius or 5,
		textures = TreeDef.textures or {{},"","","",""},
	}
	realtest.registered_trees[name] = tree
	
	minetest.register_node(tree.name.."_trunk", {
		description = tree.description.." Trunk",
		tiles = tree.textures[1],
		groups = {tree=1,snappy=1,choppy=2,flammable=2,dropping_node=1},
		sounds = default.node_sound_wood_defaults(),
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
	
	minetest.register_node(tree.name.."_planks", {
		description = tree.description.." Planks",
		tiles = {tree.textures[3]},
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_craftitem(tree.name.."_stick", {
		description = tree.description.." Stick",
		inventory_image = tree.textures[4],
		groups = {stick=1},
	})
	
	minetest.register_node(tree.name.."_sapling", {
		description = tree.description.." Sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles = {tree.textures[5]},
		inventory_image = tree.textures[5],
		wield_image = tree.textures[5],
		paramtype = "light",
		walkable = false,
		groups = {snappy=2,dig_immediate=3,flammable=2},
		sounds = default.node_sound_defaults(),
	})
	
	minetest.register_node(tree.name.."_leaves", {
		description = tree.description.." Leaves",
		drawtype = "allfaces_optional",
		visual_scale = 1.3,
		tiles = {tree.textures[2]},
		paramtype = "light",
		groups = {snappy=3, leafdecay=3, flammable=2},
		drop = {
			max_items = 1,
			items = {
				{
					items = {tree.name..'_sapling'},
					rarity = 15,
				},
				{
					items = {tree.name..'_stick'},
					rarity = 2,
				},
				{
					items = {},
				},
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		walkable = false,
		climbable = true,
	})
end

realtest.register_tree("trees:ash", {
	description = "Ash",
	leaves = trees.gen_lists.ash,
	height = function()
		return 4 + math.random(4)
	end,
	textures = {{"trees_ash_trunk_top.png", "trees_ash_trunk_top.png", "trees_ash_trunk.png"},"trees_ash_leaves.png",
		"trees_ash_planks.png", "trees_ash_stick.png", "trees_ash_sapling.png"}
})
realtest.register_tree("trees:aspen", {
	description = "Aspen",
	leaves = trees.gen_lists.aspen,
	height = function()
		return 10 + math.random(4)
	end,
	textures = {{"trees_aspen_trunk_top.png", "trees_aspen_trunk_top.png", "trees_aspen_trunk.png"},"trees_aspen_leaves.png",
		"trees_aspen_planks.png", "trees_aspen_stick.png", "trees_aspen_sapling.png"}
})
realtest.register_tree("trees:birch", {
	description = "Birch",
	leaves = trees.gen_lists.birch,
	height = function()
		return 10 + math.random(4)
	end,
	textures = {{"trees_birch_trunk_top.png", "trees_birch_trunk_top.png", "trees_birch_trunk.png"},"trees_birch_leaves.png",
		"trees_birch_planks.png", "trees_birch_stick.png", "trees_birch_sapling.png"}
})
realtest.register_tree("trees:mapple", {
	description = "Mapple",
	leaves = trees.gen_lists.mapple,
	height = function()
		return 7 + math.random(5)
	end,
	textures = {{"trees_mapple_trunk_top.png", "trees_mapple_trunk_top.png", "trees_mapple_trunk.png"},"trees_mapple_leaves.png",
		"trees_mapple_planks.png", "trees_mapple_stick.png", "trees_mapple_sapling.png"}
})
realtest.register_tree("trees:chestnut", {
	description = "Chestnut",
	leaves = trees.gen_lists.chestnut,
	height = function()
		return 9 + math.random(2)
	end,
	radius = 10,
	textures = {{"trees_chestnut_trunk_top.png", "trees_chestnut_trunk_top.png", "trees_chestnut_trunk.png"},"trees_chestnut_leaves.png",
		"trees_chestnut_planks.png", "trees_chestnut_stick.png", "trees_chestnut_sapling.png"}
})
realtest.register_tree("trees:pine", {
	description = "Pine",
	leaves = trees.gen_lists.pine,
	height = function()
		return 13 + math.random(4)
	end,
	textures = {{"trees_pine_trunk_top.png", "trees_pine_trunk_top.png", "trees_pine_trunk.png"},"trees_pine_leaves.png",
		"trees_pine_planks.png", "trees_pine_stick.png", "trees_pine_sapling.png"}
})
