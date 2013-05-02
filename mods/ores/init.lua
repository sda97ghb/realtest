--
-- Register nodes
--

ores = {}

ores.list = {
	"lignite",
	"anthracite",
	"bituminous_coal",
	"magnetite",
	"hematite",
	"limonite",
	"bismuthinite",
	"cassiterite",
	"galena",
	"garnierite",
	"malachite",
	"native_copper",
	"native_gold",
	"native_silver",
	"sphalerite",
	"tetrahedrite",
	"lapis",
	"bauxite",
	"scheelite",
	"wolframite",
	---------------------------
	'cinnabar',
	'cryolite',
	'galena',
	'garnierite',
	'graphite',
	'gypsum',
	'jet',
	'kaolinite',
	'kimberlite',
	'olovine',
	'petrified_wood',
--	'pitchblende',
	'saltpeter',
	'satinspar',
	'selenite',
	'serpentine',
	'sylvite',
	'tenorite',
}
ores.desc_list = {
	"Lignite",
	"Anthracite",
	"Bituminous Coal",
	"Magnetite",
	"Hematite",
	"Limonite",
	"Bismuthinite",
	"Cassiterite",
	"Galena",
	"Garnierite",
	"Malachite",
	"Native Copper",
	"Native Gold",
	"Native Silver",
	"Sphalerite",
	"Tetrahedrite",
	"Lapis",
	"Bauxite",
	---------------------------
	'Cinnabar',
	'Cryolite',
	'Galena',
	'Garnierite',
	'Graphite',
	'Gypsum',
	'Jet',
	'Kaolinite',
	'Kimberlite',
	'Olovine',
	'Petrified wood',
-- 	'Pitchblende',
	'Saltpeter',
	'Satinspar',
	'Selenite',
	'Serpentine',
	'Sylvite',
	'Tenorite',
}

for i,ore in ipairs(ores.list) do
	minetest.register_node("ores:"..ore, {
		description = ores.desc_list[i],
		tile_images = {"default_stone.png^ores_"..ore..".png"},
		particle_image = {"minerals_"..ore..".png"},
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		drop = {
			max_items = 1,
			items = {
				{
					items = {"minerals:"..ore.." 2"},
					rarity = 15,
				},
				{
					items = {"minerals:"..ore},
				}
			}
		},
		sounds = default.node_sound_stone_defaults(),
	})
end

minetest.register_node("ores:native_copper_desert", {
	description = "Native copper ore",
	tile_images = {"default_desert_stone.png^ores_native_copper.png"},
	particle_image = {"minerals_native_copper.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"minerals:native_copper 2"},
				rarity = 15,
			},
			{
				items = {"minerals:native_copper"},
			}
		}
	},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ores:native_gold_desert", {
	description = "Native gold ore",
	tile_images = {"default_desert_stone.png^ores_native_gold.png"},
	particle_image = {"minerals_native_gold.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"minerals:native_gold 2"},
				rarity = 15,
			},
			{
				items = {"minerals:native_gold"},
			}
		}
	},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ores:sulfur", {
	description = "Sulfur ore",
	drawtype = "signlike",
	tile_images = {"ores_sulfur.png"},
	particle_image = {"minerals_sulfur.png"},
	is_ground_content = true,
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {cracky=3,drop_on_dig=1,dig_immediate=2},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"minerals:sulfur 3"},
				rarity = 15,
			},
			{
				items = {"minerals:sulfur 2"},
			}
		}
	},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ores:peat", {
	description = "Peat",
	tile_images = {"ores_peat.png"},
	particle_image = {"ores_peat.png"},
	is_ground_content = true,
	groups = {crumbly=3,drop_on_dig=1,falling_node=1},
	sounds = default.node_sound_stone_defaults(),
})

--
-- Generation ores
--

local function generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, height_min, height_max)
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
					if minetest.env:get_node(p2).name == wherein then
						minetest.env:set_node(p2, {name=name})
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

local function generate_peat(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, height_min, height_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	
	for j=y_min, y_max-chunk_size+1 do
		for i=minp.x, maxp.x-chunk_size+1 do
			for k=minp.z, maxp.z-chunk_size+1 do
				if minetest.env:get_node({x=i, y=j, z=k}).name == wherein and minetest.env:get_node({x=i, y=j + 1, z=k}).name == "default:water_source" then
					if  minetest.env:get_node({x=i, y=j + 2, z=k}).name == "air" then
						minetest.env:set_node({x=i, y=j, z=k}, {name=name})
					end
					if minetest.env:get_node({x=i, y=j + 2, z=k}).name == "default:water_source" and 
						minetest.env:get_node({x=i, y=j + 3, z=k}).name == "air" then
						minetest.env:set_node({x=i, y=j, z=k}, {name=name})
					end
				end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed)
	local gen_ores = {
		{"ores:lignite", -3000, -500},
		{"ores:bituminous_coal", -6000, -3000},
		{"ores:anthracite", -8000, -6000},
		{"ores:bismuthinite"},
		{"ores:magnetite"},
		{"ores:hematite"},
		{"ores:limonite"},
		{"ores:cassiterite"},
		{"ores:galena"},
		{"ores:garnierite"},
		{"ores:malachite"},
		{"ores:native_copper"},
		{"ores:native_gold"},
		{"ores:native_silver"},
		{"ores:sphalerite"},
		{"ores:tetrahedrite"},
		{"ores:bauxite"},
		{"ores:scheelite"},
		{"ores:wolframite"},
		{"ores:lapis"},
		{'ores:cinnabar'},
		{'ores:cryolite'},
		{'ores:galena'},
		{'ores:garnierite'},
		{'ores:graphite', -31000, -8000},
		{'ores:gypsum'},
		{'ores:jet'},
		{'ores:kaolinite'},
		{'ores:kimberlite'},
		{'ores:olovine'},
		{'ores:petrified_wood'},
	--	{'ores:pitchblende'},
		{'ores:saltpeter'},
		{'ores:satinspar'},
		{'ores:selenite'},
		{'ores:serpentine'},
		{'ores:sylvite'},
		{'ores:tenorite'},
	}
	for i, ore in ipairs(gen_ores) do
		if pr:next(1,2) == 1 then
			generate_ore(ore[1], "default:stone", minp, maxp, seed+i, 1/8/8/8/8/8/8, 10, 850, ore[2] or -31000, ore[3] or 200)
		end
	end
	generate_sulfur("ores:sulfur", minp, maxp, seed, 1/8/8/8/8, 10, 850, -31000, 200)
	generate_peat("ores:peat", "default:dirt", minp, maxp, seed+19, 1/8/16/24, 10, 1000, -100, 200)
	generate_ore("ores:native_copper_desert", "default:desert_stone", minp, maxp, seed+20, 1/8/8/8/8/8/8, 6, 200, -31000, 200)
	generate_ore("ores:native_gold_desert", "default:desert_stone", minp, maxp, seed+21, 1/8/8/8/8/8/8, 5, 100, -31000, 200)
	generate_ore("ores:platinum", "ores:magnetite", minp, maxp, seed+22, 1/8/8/8/8/8/8, 10, 850, -31000, 200)
	
	if pr:next(1,2) == 1 then		-- Generate clay
		local divlen = 10
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0+1,divs-1-1 do
		for divz=0+1,divs-1-1 do
			local cx = minp.x + math.floor((divx+0.5)*divlen)
			local cz = minp.z + math.floor((divz+0.5)*divlen)
			if minetest.env:get_node({x=cx,y=1,z=cz}).name == "default:water_source" then
				local is_shallow = true
				local num_water_around = 0
				if minetest.env:get_node({x=cx-divlen*2,y=1,z=cz+0}).name == "default:water_source" then
					num_water_around = num_water_around + 1 end
				if minetest.env:get_node({x=cx+divlen*2,y=1,z=cz+0}).name == "default:water_source" then
					num_water_around = num_water_around + 1 end
				if minetest.env:get_node({x=cx+0,y=1,z=cz-divlen*2}).name == "default:water_source" then
					num_water_around = num_water_around + 1 end
				if minetest.env:get_node({x=cx+0,y=1,z=cz+divlen*2}).name == "default:water_source" then
					num_water_around = num_water_around + 1 end
				if num_water_around >= 2 then
					is_shallow = false
				end	
				if is_shallow then
					local y = pr:next(0,2)
					for y1=y,pr:next(y,y+1) do
					for x1=-divlen,divlen do
					for z1=-divlen,divlen do
						if minetest.env:get_node({x=cx+x1,y=y1,z=cz+z1}).name == "default:sand" and 
							minetest.env:get_node({x=cx+x1,y=y1+1,z=cz+z1}).name == "default:water_source" then
							minetest.env:set_node({x=cx+x1,y=y1,z=cz+z1}, {name="default:sand_with_clay"})
						elseif minetest.env:get_node({x=cx+x1,y=y1,z=cz+z1}).name == "default:dirt" then
							minetest.env:set_node({x=cx+x1,y=y1,z=cz+z1}, {name="default:dirt_with_clay"})
						elseif minetest.env:get_node({x=cx+x1,y=y1,z=cz+z1}).name == "default:dirt_with_grass" then
							minetest.env:set_node({x=cx+x1,y=y1,z=cz+z1}, {name="default:dirt_with_grass_and_clay"})
						end	
					end
					end
					end
				end
			end
		end
		end
	end
end)

minetest.register_alias("ores:brown_coal","ores:lignite")

--
-- Recipes of crafting
--

minetest.register_craft({
	type = "cooking",
	output = "default:torch 2",
	recipe = "group:stick",
})

minetest.register_craft({
	type = "fuel",
	recipe = "ores:peat",
	burntime = 15,
})
