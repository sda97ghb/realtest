dofile(minetest.get_modpath("trees").."/leavesgen.lua")

trees = {}

trees.grounds = {
	"default:dirt",
	"default:dirt_with_grass",
}

trees.list = {
	"ash",
	"aspen",
	"birch",
	"chestnut",
	"mapple",
	"pine",
}

trees.desc_list = {
	"Ash",
	"Aspen",
	"Birch",
	"Chestnut",
	"Mapple",
	"Pine",
}

for i, tree in ipairs(trees.list) do
	minetest.register_node("trees:"..tree.."_trunk", {
		description = trees.desc_list[i].." Trunk",
		tiles = {"trees_"..tree.."_trunk_top.png", "trees_"..tree.."_trunk_top.png", "trees_"..tree.."_trunk.png"},
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
	
	minetest.register_node("trees:"..tree.."_leaves", {
		description = trees.desc_list[i].." Leaves",
		drawtype = "allfaces_optional",
		visual_scale = 1.3,
		tiles = {"trees_"..tree.."_leaves.png"},
		paramtype = "light",
		groups = {snappy=3, leafdecay=3, flammable=2},
		drop = {
			max_items = 1,
			items = {
				{
					items = {'trees:'..tree..'_sapling'},
					rarity = 15,
				},
				{
					items = {'trees:'..tree..'_stick'},
					rarity = 2,
				},
				{
					items = {"trees:"..tree.."_leaves"},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		walkable = false,
		climbable = true,
	})
	
	minetest.register_node("trees:"..tree.."_planks", {
		description = trees.desc_list[i].." Planks",
		tiles = {"trees_"..tree.."_planks.png"},
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_craftitem("trees:"..tree.."_stick", {
		description = trees.desc_list[i].." Stick",
		inventory_image = "trees_"..tree.."_stick.png",
		groups = {sticks=1},
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			trees.make_tree(pointed_thing.above, 4, 12, TREES_GEN_PINE_LIST, "trees:"..tree.."_trunk", "trees:"..tree.."_leaves")
		end,
	})
	
	minetest.register_node("trees:"..tree.."_sapling", {
		description = trees.desc_list[i].." Sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles = {"trees_"..tree.."_sapling.png"},
		inventory_image = "trees_"..tree.."_sapling.png",
		wield_image = "trees_"..tree.."_sapling.png",
		paramtype = "light",
		walkable = false,
		groups = {snappy=2,dig_immediate=3,flammable=2},
		sounds = default.node_sound_defaults(),
	})
	
	--[[minetest.register_abm({
		nodenames = {"trees:"..tree.."_sapling"},
		interval = 9.0,
		chance = 1.0,
		action = function(pos, node, active_object_count, active_object_count_wider)
			posn = {x=pos.x, y=pos.y-1, z=pos.z}
			minetest.env:set_node(pos,{name="air"})
			local s = minetest.env:get_node(posn).name
			if s ~= "default:dirt" and s ~= "default:dirt_with_grass" then return end
			--gen_ash(posn)
		end,
	})]]
end

function trees.make_tree(pos, arlenght, height, genlist, trunk, leaves)
	for i, tree in ipairs(trees.list) do
		if minetest.env:find_node_near(pos, arlenght, "trees:"..tree.."_trunk") then
			return
		end
	end
	for i = 0,height do
		if minetest.env:get_node({x=pos.x, y=pos.y+i, z=pos.z}).name == "air" then
			minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name=trunk})
		end
	end
	for i = 1,#genlist do
		local p = {x=pos.x+genlist[i][1], y=pos.y+height+genlist[i][2], z=pos.z+genlist[i][3]}
		if minetest.env:get_node(p).name == "air" then
			minetest.env:add_node(p, {name=leaves})
		end
	end
end

function trees.get_tree_height(trunk)
	local height = {
		["trees:ash_trunk"] = 4 + math.random(4),
		["trees:mapple_trunk"] = 7 + math.random(5),
		["trees:birch_trunk"] = 10 + math.random(4),
		["trees:aspen_trunk"] = 10 + math.random(4),
		["trees:chestnut_trunk"] = 9 + math.random(2),
		["trees:pine_trunk"] = 13 + math.random(4),
	}
	return height[trunk]
end

local function generate(genlist, arlenght, trunk, leaves, wherein, minp, maxp, seed, chunks_per_volume, ore_per_chunk, height_min, height_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local chunk_size = 3
	if ore_per_chunk <= 4 then
		chunk_size = 2
	end
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	for i=1,num_chunks do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= height_min and y0 <= height_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			for x1=0,chunk_size-1 do
				for y1=0,chunk_size-1 do
					for z1=0,chunk_size-1 do
						if pr:next(1,inverse_chance) == 1 then
							local x2 = x0+x1
							local y2 = y0+y1
							local z2 = z0+z1
							local p2 = {x=x2, y=y2, z=z2}
							local p3 = {x=x2, y=y2+1, z=z2}
							if (minetest.env:get_node(p2).name == wherein) and (minetest.env:get_node(p3).name == "air") then
								trees.make_tree(p2, arlenght, trees.get_tree_height(trunk), genlist, trunk, leaves)
							end
						end
					end
				end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	if pr:next(1,3) == 1 then
		generate(TREES_GEN_ASH_LIST, 5, "trees:ash_trunk","trees:ash_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -50, 100)
	end
	if pr:next(1,6) == 1 then
		generate(TREES_GEN_MAPPLE_LIST, 5,"trees:mapple_trunk", "trees:mapple_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -50, 100)
	end
	if pr:next(1,6) == 1 then
		generate(TREES_GEN_BIRCH_LIST, 5, "trees:birch_trunk", "trees:birch_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -50, 100)
	end
	if pr:next(1,6) == 1 then
		generate(TREES_GEN_ASPEN_LIST, 5, "trees:aspen_trunk", "trees:aspen_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -50, 100)
	end
	if pr:next(1,6) == 1 then
		generate(TREES_GEN_CHESTNUT_LIST, 10, "trees:chestnut_trunk", "trees:chestnut_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -50, 100)
	end
	if pr:next(1,6) == 1 then
		generate(TREES_GEN_PINE_LIST, 6, "trees:pine_trunk", "trees:pine_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -50, 100)
	end
end)
