dofile(minetest.get_modpath("trees").."/treegen.lua")

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
		description = "Log of "..trees.desc_list[i],
		tiles = {"trees_"..tree.."_trunk_top.png", "trees_"..tree.."_trunk_top.png", "trees_"..tree.."_trunk.png"},
		is_ground_content = true,
		groups = {tree=1,snappy=1,choppy=2,flammable=2},
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
		description = "Leaves of "..trees.desc_list[i],
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
	
	minetest.register_node("trees:"..tree.."_wood", {
		description = "Wooden Planks of "..trees.desc_list[i],
		tiles = {"trees_"..tree.."_wood.png"},
		is_ground_content = true,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_craftitem("trees:"..tree.."_stick", {
		description = "Stick of "..trees.desc_list[i],
		inventory_image = "trees_"..tree.."_stick.png",
		groups = {sticks=3},
		--[[on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			minetest.env:set_node(pointed_thing.above,{name="trees:pine_trunk"})
			gen_tree(pointed_thing.above, 4, 12, TREES_GEN_PINE_LIST, "trees:pine_trunk", "trees:pine_leaves")
		end,]]
	})
	
	minetest.register_node("trees:"..tree.."_sapling", {
		description = "Sapling of "..trees.desc_list[i],
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
		nodenames = {"trees:"..TREES_LIST[i].."_sapling"},
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
	
	minetest.register_abm({
		nodenames = {"trees:"..tree.."_trunk"},
		interval = 1.0,
		chance = 1.0,
		action = function(pos, node, active_object_count, active_object_count_wider)
			if table.contains(trees.grounds, minetest.env:get_node({x = pos.x, y = pos.y-1, z = pos.z}).name) then return end
			for x = -1, 1 do
				for z = -1, 1 do
					local posn={x = pos.x+x, y = pos.y-1, z = pos.z+z}
					if minetest.env:get_node(posn).name == "trees:"..tree.."_trunk" then
						return
					end
				end
			end
			minetest.env:add_item(pos, "trees:"..tree.."_trunk")
			minetest.env:add_node(pos, {name="air"})
		end,
	})
end

function set_node_instead_air(ipos, i, j, k, block)
	local pos = {x=ipos.x+i,y=ipos.y+j,z=ipos.z+k}
	if minetest.env:get_node(pos).name == "air" then minetest.env:set_node(pos, block) end
end

function gen_tree(ipos, arlenght, height, genlist, trunk, leaves)
	local pos = ipos
	if minetest.env:find_node_near(pos, arlenght, trunk) then return end
	for i=1,height do
		set_node_instead_air({x=pos.x, y=pos.y+i, z=pos.z},0,0,0,{name=trunk})
	end
	local loc_leaves={name=leaves}
	for i=1,#genlist do
		set_node_instead_air(pos, genlist[i][1], height+genlist[i][2], genlist[i][3], loc_leaves)
	end
end

local get_height = function(tree)
if tree=="trees:ash_trunk" then return 4+math.random(4) end
if tree=="trees:mapple_trunk" then return 7+math.random(5) end
if tree=="trees:birch_trunk" then return 10+math.random(4) end
if tree=="trees:aspen_trunk" then return 10+math.random(4) end
if tree=="trees:chestnut_trunk" then return 9+math.random(2) end
if tree=="trees:pine_trunk" then return 13+math.random(4) end
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
								gen_tree(p2, arlenght, get_height(trunk), genlist, trunk, leaves)
							end
						end
					end
				end
			end
		end
	end
end

minetest.register_on_generated(
function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	minetest.after(0,
	function()
		if pr:next(1,3) == 1 then
			generate(TREES_GEN_ASH_LIST, 5, "trees:ash_trunk","trees:ash_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -1000, 10000)
		end
		if pr:next(1,6) == 1 then
			generate(TREES_GEN_MAPPLE_LIST, 5,"trees:mapple_trunk", "trees:mapple_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -1000, 10000)
		end
		if pr:next(1,6) == 1 then
			generate(TREES_GEN_BIRCH_LIST, 5, "trees:birch_trunk", "trees:birch_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -1000, 10000)
		end
		if pr:next(1,6) == 1 then
			generate(TREES_GEN_ASPEN_LIST, 5, "trees:aspen_trunk", "trees:aspen_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -1000, 10000)
		end
		if pr:next(1,6) == 1 then
			generate(TREES_GEN_CHESTNUT_LIST, 10, "trees:chestnut_trunk", "trees:chestnut_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -1000, 10000)
		end
		if pr:next(1,6) == 1 then
			generate(TREES_GEN_PINE_LIST, 6, "trees:pine_trunk", "trees:pine_leaves", "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -1000, 10000)
		end
	  end)
	
end)
