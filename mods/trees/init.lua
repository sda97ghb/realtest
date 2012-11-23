trees = {}

dofile(minetest.get_modpath("trees").."/leavesgen.lua")

function trees.make_tree(pos, tree)
	local tree = realtest.registered_trees[tree]
	if not table.contains(tree.grounds, minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name) then
		return
	end
	local height = tree.height()
	for i = 1,height do
		if minetest.env:get_node({x=pos.x, y=pos.y+i, z=pos.z}).name ~= "air" then
			return
		end
	end
	for i = 0,height do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name=tree.name.."_trunk"})
	end
	for i = 1,#tree.leaves do
		local p = {x=pos.x+tree.leaves[i][1], y=pos.y+height+tree.leaves[i][2], z=pos.z+tree.leaves[i][3]}
		if minetest.env:get_node(p).name == "air" or minetest.env:get_node(p).name == "ignore" then
			minetest.env:add_node(p, {name=tree.name.."_leaves"})
		end
	end
end

local function generate(tree, minp, maxp, seed)
	local perlin1 = minetest.env:get_perlin(329, 3, 0.6, 100)
	-- Assume X and Z lengths are equal
	local divlen = 16
	local divs = (maxp.x-minp.x)/divlen+1;
	for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			-- Determine trees amount from perlin noise
			local trees_amount = math.floor(perlin1:get2d({x=x0, y=z0}) * 5 + 0)
			-- Find random positions for trees based on this random
			local pr = PseudoRandom(seed)
			for i=0,trees_amount do
				local x = pr:next(x0, x1)
				local z = pr:next(z0, z1)
				-- Find ground level (0...30)
				local ground_y = nil
				for y=30,0,-1 do
					if minetest.env:get_node({x=x,y=y,z=z}).name ~= "air" then
						ground_y = y
						break
					end
				end
				if ground_y then
					trees.make_tree({x=x,y=ground_y+1,z=z}, tree)
				end
			end
		end
	end
end

dofile(minetest.get_modpath("trees").."/registration.lua")

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	for key, value in pairs(realtest.registered_trees) do
		if pr:next(1, 10) == 1 then
			generate(key, minp, maxp, seed, 1/8/2, 1)
		end
	end
end)
