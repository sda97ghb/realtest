biomes = {}

biomes.stones_list = {
	"diorite",
	"gabbro",
	"granite",
	"andesite",
	"basalt",
	"dacite",
	"rhyolite",
	"chalk",
	"chert",
	"claystone",
	"conglomerate",
	"dolomite",
	"limestone",
	"mudstone",
	"rock_salt",
	"shale",
	"siltstone",
	"gneiss",
	"marble",
	"phyllite",
	"quartzite",
	"schist",
	"slate"
}

biomes.stones_desc_list = {
	"Diorite",
	"Gabbro",
	"Granite",
	"Andesite",
	"Basalt",
	"Dacite",
	"Rhyolite",
	"Chalk",
	"Chert",
	"Claystone",
	"Conglomerate",
	"Dolomite",
	"Limestone",
	"Mudstone",
	"Rock Salt",
	"Shale",
	"Siltstone",
	"Gneiss",
	"Marble",
	"Phyllite",
	"Quartzite",
	"Schist",
	"Slate"
}

biomes.sands_list = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"11",
	"12",
	"13",
	"14",
	"15",
	"16",
	"17",
	"18",
	"19",
	"20",
	"21",
	"22",
	"23"
}

biomes.dirts_list = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"11",
	"12",
	"13",
	"14",
	"15",
	"16",
	"17",
	"18",
	"19",
	"20",
	"21",
	"22",
	"23"
}

for i, stone in ipairs(biomes.stones_list) do
	minetest.register_node("biomes:stone_"..stone, {
		description = biomes.stones_desc_list[i],
		tiles = {"biomes_stone_"..stone..".png"},
		particle_image = {"biomes_cobble_"..stone..".png"},
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		drop = {
			max_items = 1,
			items = {
				{
					items = {"biomes:cobble_"..stone, "minerals:borax"},
					rarity = 50,
				},
				{
					items = {"biomes:cobble_"..stone, "biomes:cobble_"..stone, "biomes:cobble_"..stone},
					rarity = 5
				},
				{
					items = {"biomes:cobble_"..stone, "biomes:cobble_"..stone}
				},
				{
					items = {"biomes:cobble_"..stone},
					rarity = 5
				},
			},
		},
		sounds = default.node_sound_stone_defaults()
	})
	minetest.register_craftitem("biomes:cobble_"..stone, {
		description = biomes.stones_desc_list[i],
		inventory_image = "biomes_cobble_"..stone..".png"
	})
	minetest.register_node("biomes:cobble_node_"..stone, {
		tiles = {"biomes_stone_"..stone..".png"},
		particle_image = {"biomes_cobble_"..stone..".png"},
		paramtype = "light",
		sunlight_propagates = true,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-0.5+9/32, -0.5, -0.5+12/32, 0.5-9/32, -0.5+1/8, 0.5-12/32},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5+9/32, -0.5, -0.5+12/32, 0.5-9/32, -0.5+1/8, 0.5-12/32},
		},
		drop = "biomes:cobble_"..stone,
		groups = {dig_immediate=2,dropping_node=1,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})
	end

for i, sand in ipairs(biomes.sands_list) do
	minetest.register_node("biomes:sand_"..sand, {
		description = "Sand",
		tiles = {"biomes_sand_"..sand..".png"},
		particle_image = {"biomes_sand_"..sand..".png"},
		is_ground_content = true,
		groups = {crumbly=3,drop_on_dig=1,falling_node=1},
		sounds = default.node_sound_sand_defaults(),
	})
end

for i, dirt in ipairs(biomes.dirts_list) do
	minetest.register_node("biomes:dirt_"..dirt, {
		description = "Dirt",
		tiles = {"biomes_dirt_"..dirt..".png"},
		particle_image = {"biomes_dirt_"..dirt..".png"},
		is_ground_content = true,
		groups = {crumbly=3,drop_on_dig=1,falling_node=1},
		sounds = default.node_sound_dirt_defaults(),
	})
end
