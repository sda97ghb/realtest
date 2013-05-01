local function generate_peat(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, height_min, height_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	--print("generate_ore num_chunks: "..dump(num_chunks))
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
					if minetest.env:get_node(p2).name == wherein then
						if minetest.env:get_node({x=p2.x, y=p2.y + 1, z=p2.z}).name == "default:water_source" and
						minetest.env:get_node({x=p2.x, y=p2.y + 2, z=p2.z}).name == "air" then
							minetest.env:set_node(p2, {name=name})
						end
						if minetest.env:get_node({x=p2.x, y=p2.y + 1, z=p2.z}).name == "default:water_source" and
						minetest.env:get_node({x=p2.x, y=p2.y + 2, z=p2.z}).name == "default:water_source" and 
						minetest.env:get_node({x=p2.x, y=p2.y + 3, z=p2.z}).name == "air" then
							minetest.env:set_node(p2, {name=name})
						end
						
					end
				end
			end
			end
			end
		end
	end
end

local function is_node_beside(pos, node)
	local sides = {{x=-1,y=0,z=0}, {x=1,y=0,z=0}, {x=0,y=0,z=-1}, {x=0,y=0,z=1}, {x=0,y=-1,z=0}, {x=0,y=1,z=0},}
	for i, s in ipairs(sides) do
		if minetest.env:get_node({x=pos.x+s.x,y=pos.y+s.y,z=pos.z+s.z}).name == node then
			return true, minetest.dir_to_wallmounted(s)
		end
	end
	return false
end

local function generate_sulfur(name, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, height_min, height_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
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
					if minetest.env:get_node(p2).name == "air" and minetest.env:find_node_near(p2, 3, {"default:lava_source","default:lava_flowing"}) then
						local inb, side = is_node_beside(p2, "default:stone")
						if inb then
							minetest.env:set_node(p2, {name=name, param2 = side})
						end
					end
				end
			end
			end
			end
		end
	end
end

local function generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size,
	ore_per_chunk, height_min, height_max, noise_min, noise_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local ore_noise1
	local ore_noise2
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	
	-- perlin. Only done if borders are defined.
	if type(noise_min) == "number" or type(noise_max) == "number" then
		if type(noise_min) ~= "number" then
			noise_min = -2
		end
		if type(noise_max) ~= "number" then
			noise_max = 2
		end
		ore_noise1 = minetest.env:get_perlin(seed, 3, 0.7, 100)
	end
	
	--print("generate_ore num_chunks: "..dump(num_chunks))
	for i=1,num_chunks do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= height_min and y0 <= height_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			
			-- perlin
			if type(noise_min) == "number" or type(noise_max) == "number" then
				ore_noise2 = (ore_noise1:get3d(p0))
			end
			
			for x1=0,chunk_size-1 do
			for y1=0,chunk_size-1 do
			for z1=0,chunk_size-1 do
				if pr:next(1,inverse_chance) == 1 then
					local x2 = x0+x1
					local y2 = y0+y1
					local z2 = z0+z1
					local p2 = {x=x2, y=y2, z=z2}
					if minetest.env:get_node(p2).name == wherein then
							
							-- perlin
							if type(noise_min) == "number" or type(noise_max) == "number" then
								if ore_noise2 >= noise_min and ore_noise2 <= noise_max then
									minetest.env:set_node(p2, {name=name})
								end
							else
								minetest.env:set_node(p2, {name=name})
							end
							
					end
				end
			end
			end
			end
		end
	end
	--print("generate_perlinore done")
end

minetest.after(0, function()
	minetest.register_on_generated(function(minp, maxp, seed)
		local pr = PseudoRandom(seed)
		local ore = realtest.registered_ores[realtest.registered_ores_list[pr:next(1,#realtest.registered_ores_list)]]
	
		for __, wherein in ipairs(ore.wherein) do
			generate_ore(ore.name.."_in_"..wherein:gsub(":","_"), wherein, minp, maxp, seed+ore.delta_seed,
				ore.chunks_per_volume, ore.chunk_size,
				ore.ore_per_chunk, ore.height_min, ore.height_max, ore.noise_min, ore.noise_max)
		end
		generate_sulfur("ores:sulfur", minp, maxp, seed+400, 1/8/8/8/8, 10, 850, -30912, 200)
		generate_peat("ores:peat", "default:dirt", minp, maxp, seed+401, 1/8/16/24, 10, 1000, -100, 200)
	end)
end)