minetest.register_abm({
	nodenames = {'default:tree','default:leaves'},
	interval = 1.0,
	chance = 1.0,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.env:add_node(pos, {name="air"})
	end,
})

GROUND_LIST={
	'default:dirt',
	'default:dirt_with_grass',
}

local table_containts = function(t, v)
	for _, i in ipairs(t) do
		if i==v then
			return true
		end
	end
	return false
end

-- minetest.register_abm({
-- 	nodenames = {'trees:mapple_trunk'},
-- 	interval = 1.0,
-- 	chance = 1.0,
-- 	action = function(pos, node, active_object_count, active_object_count_wider)
-- 		if table_containts(GROUND_LIST, minetest.env:get_node({x = pos.x, y = pos.y-1, z = pos.z}).name) then return end
-- 		for i = -1, 1 do
-- 			for k = -1, 1 do
-- 				if minetest.env:get_node({x = pos.x+i, y = pos.y-1, z = pos.z+k}).name == 'trees:mapple_trunk' then return end
-- 			end
-- 		end
-- 		minetest.env:add_item(pos, "trees:mapple_trunk")
-- 		minetest.env:add_node(pos, {name="air"})
-- 	end,
-- })

TREES_LIST={
	"mapple",
}

for i=1,#TREES_LIST do
	minetest.register_node("trees:"..TREES_LIST[i].."_trunk", {
		description = "Log of "..TREES_LIST[i],
		tiles = {"trees_"..TREES_LIST[i].."_trunk_top.png", "trees_"..TREES_LIST[i].."_trunk_top.png", "trees_"..TREES_LIST[i].."_trunk.png"},
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
		climbable = true,
	})
	
	minetest.register_node("trees:"..TREES_LIST[i].."_leaves", {
		description = "Leaves of "..TREES_LIST[i],
		drawtype = "allfaces_optional",
		visual_scale = 1.3,
		tiles = {"trees_"..TREES_LIST[i].."_leaves.png"},
		paramtype = "light",
		groups = {snappy=3, leafdecay=3, flammable=2},
		drop = {
			max_items = 1,
			items = {
				{
					items = {'trees:trees_'..TREES_LIST[i]..'_sapling'},
					rarity = 20,
				},
				{
					items = {"trees:"..TREES_LIST[i].."_leaves"},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		walkable = false,
		climbable = true,
	})
	
	minetest.register_node("trees:"..TREES_LIST[i].."_wood", {
		description = "Wooden Planks of "..TREES_LIST[i],
		tiles = {"trees_"..TREES_LIST[i].."_wood.png"},
		inventory_image = "",
		is_ground_content = true,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_craftitem("trees:"..TREES_LIST[i].."_stick", {
		description = "Stick of "..TREES_LIST[i],
		inventory_image = "trees_"..TREES_LIST[i].."_stick.png",
		groups = {sticks=3},
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			local pos = pointed_thing.under
			gen_mapple(pos)
			
		end,
	})
end

function set_node_instead_air(pos, block)
	if minetest.env:get_node(pos).name == "air" then minetest.env:set_node(pos, block) end
end

function gen_mapple(ipos)
	local pos = ipos
	for i=-5,5 do
		for j=-5,5 do
			for k=-5,5 do
				local s = minetest.env:get_node({x=pos.x+i,y=pos.y+j,z=pos.z+k}).name
				if s ~= "air" then
				if s ~= "default:dirt" then
				if s ~= "default:dirt_with_grass" then
				if s ~= "default:stone" then
				if s ~= "default:tree" then
				if s ~= "default:leaves" then
					return
				end
				end
				end
				end
				end
				end
			end
		end
	end
	local height = 7 + math.random(5)
	for i=1,height do
		if minetest.env:get_node({x=pos.x, y=pos.y+i, z=pos.z}).name == "air" then
			minetest.env:set_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="trees:mapple_trunk"})
		end
	end
	-----------------------------------------------------------------------------------------------
	set_node_instead_air({x=pos.x, y=pos.y+height+1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height+1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height+1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height+1, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height+1, z=pos.z+1}, {name="trees:mapple_leaves"})
	-----------------------------------------------------------------------------------------------
	set_node_instead_air({x=pos.x-1, y=pos.y+height, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height, z=pos.z+1}, {name="trees:mapple_leaves"})
	-----------------------------------------------------------------------------------------------
	set_node_instead_air({x=pos.x-1, y=pos.y+height-1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-1, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-1, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-1, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-1, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-1, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-1, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-1, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-1, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-1, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-1, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-1, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-1, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-1, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-1, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-1, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-1, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-1, z=pos.z+2}, {name="trees:mapple_leaves"})
	-----------------------------------------------------------------------------------------------
	set_node_instead_air({x=pos.x-1, y=pos.y+height-2, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-2, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-2, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-2, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-2, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-2, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-2, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-2, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-2, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-2, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-2, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-2, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-2, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-2, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-2, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-2, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-2, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-2, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-2, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-2, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-2, z=pos.z-2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-2, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-2, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-2, z=pos.z-2}, {name="trees:mapple_leaves"})
	-----------------------------------------------------------------------------------------------
	set_node_instead_air({x=pos.x-1, y=pos.y+height-3, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-3, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-1, y=pos.y+height-3, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-3, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-3, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-3, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x,   y=pos.y+height-3, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x,   y=pos.y+height-3, z=pos.z-1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x-2, y=pos.y+height-3, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+2, y=pos.y+height-3, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-3, z=pos.z+2}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x, y=pos.y+height-3, z=pos.z-2}, {name="trees:mapple_leaves"})
	-----------------------------------------------------------------------------------------------
	set_node_instead_air({x=pos.x-1, y=pos.y+height-4, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x+1, y=pos.y+height-4, z=pos.z}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x,   y=pos.y+height-4, z=pos.z+1}, {name="trees:mapple_leaves"})
	set_node_instead_air({x=pos.x,   y=pos.y+height-4, z=pos.z-1}, {name="trees:mapple_leaves"})
end

local function generate(name, wherein, minp, maxp, seed, chunks_per_volume, ore_per_chunk, height_min, height_max)
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
								name(p2)
							end
						end
					end
				end
			end
		end
	end
end

-- local function generate_ore(minp, maxp, trees_per_volume, height_min, height_max)
-- 	if maxp.y < height_min or minp.y > height_max then
-- 		return
-- 	end
-- 	for j=minp.y, maxp.y do
-- 		for i=1,trees_per_volume do
-- 			local pos = {x=minp.x+math.random(15), y=minp.y+j, z=minp.z+math.random(15)}
-- 			if minetest.env:get_node(pos).name == "default:dirt_with_grass" then
-- 				gen_mapple(pos)
-- 			end
-- 		end
-- 	end
-- end

minetest.register_on_generated(
function(minp, maxp, seed)
	--if math.random(2) == 1 then generate_ore(minp, maxp, 10, -100,  31000) end
	if math.random(6) == 1 then generate(gen_mapple, "default:dirt_with_grass", minp, maxp, seed, 1/8/2, 1, -100, 2000) end
end)