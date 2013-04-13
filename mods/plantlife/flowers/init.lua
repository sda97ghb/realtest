-- This module supplies flowers for the plantlife modpack

local spawn_delay = 2000 -- 2000
local spawn_chance = 100 -- 100
local grow_delay = 1000 -- 1000
local grow_chance = 10 -- 10

local flowers_list = {
	{ "Rose",		"rose", 		spawn_delay,	10,	spawn_chance	, 10},
	{ "Tulip",		"tulip",		spawn_delay,	10,	spawn_chance	, 10},
	{ "Yellow Dandelion",	"dandelion_yellow",	spawn_delay,	10,	spawn_chance*2	, 10},
	{ "White Dandelion",	"dandelion_white",	spawn_delay,	10,	spawn_chance*2	, 10},
	{ "Blue Geranium",	"geranium",		spawn_delay,	10,	spawn_chance	, 10},
	{ "Viola",		"viola",		spawn_delay,	10,	spawn_chance	, 10},
	{ "Cotton Plant",	"cotton",		spawn_delay,	10,	spawn_chance*2	, 10},
}

for i in ipairs(flowers_list) do
	local flowerdesc = flowers_list[i][1]
	local flower     = flowers_list[i][2]
	local delay      = flowers_list[i][3]
	local radius     = flowers_list[i][4]
	local chance     = flowers_list[i][5]

	minetest.register_node(":flowers:flower_"..flower, {
		description = flowerdesc,
		drawtype = "plantlike",
		tiles = { "flower_"..flower..".png" },
		inventory_image = "flower_"..flower..".png",
		wield_image = "flower_"..flower..".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		groups = { snappy = 3,flammable=2, flower=1, drop_on_dig=1 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
		},	
	})

	minetest.register_node(":flowers:flower_"..flower.."_pot", {
		description = flowerdesc.." in a pot",
		drawtype = "plantlike",
		tiles = { "flower_"..flower.."_pot.png" },
		inventory_image = "flower_"..flower.."_pot.png",
		wield_image = "flower_"..flower.."_pot.png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		groups = { snappy = 3,flammable=2, drop_on_dig=1 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0.5, 0.25 },
		},	
	})

	minetest.register_craft( {
		type = "shapeless",
		output = "flowers:flower_"..flower.."_pot",
		recipe = {
			"flowers:flower_pot",
			"flowers:flower_"..flower
		}
	})

	spawn_on_surfaces(delay, "flowers:flower_"..flower, radius, chance, "default:dirt_with_grass", {"group:flower", "group:poisonivy"}, flowers_seed_diff)
end

minetest.register_node(":flowers:flower_waterlily", {
	description = "Waterlily",
	drawtype = "raillike",
	tiles = { "flower_waterlily.png" },
	inventory_image = "flower_waterlily.png",
	wield_image  = "flower_waterlily.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1, drop_on_dig=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
	},	
})

minetest.register_node(":flowers:flower_seaweed", {
	description = "Seaweed",
	drawtype = "signlike",
	tiles = { "flower_seaweed.png" },
	inventory_image = "flower_seaweed.png",
	wield_image  = "flower_seaweed.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1, drop_on_dig=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, -0.4, 0.5 },
	},	
})

spawn_on_surfaces(spawn_delay/2, "flowers:flower_waterlily", 3,   spawn_chance*2, "default:water_source"   , {"group:flower"}, flowers_seed_diff, 10, nil, nil,                         nil, nil, 4)

spawn_on_surfaces(spawn_delay*2, "flowers:flower_seaweed"  , 0.1, spawn_chance*2, "default:water_source"   , {"group:flower"}, flowers_seed_diff,  4,  10, {"default:dirt_with_grass"},   0,   1)
spawn_on_surfaces(spawn_delay*2, "flowers:flower_seaweed"  , 0.1, spawn_chance*2, "default:dirt_with_grass", {"group:flower"}, flowers_seed_diff,  4,  10, {"default:water_source"}   ,   1,   1)
spawn_on_surfaces(spawn_delay*2, "flowers:flower_seaweed"  , 0.1, spawn_chance*2, "default:stone"          , {"group:flower"}, flowers_seed_diff,  4,  10, {"default:water_source"}   ,   6,   1)


minetest.register_craftitem(":flowers:flower_pot", {
	description = "Flower Pot",
	inventory_image = "flower_pot.png",
})

minetest.register_craft( {
	output = "flowers:flower_pot",
	recipe = {
	        { "default:clay_brick", "", "default:clay_brick" },
	        { "", "default:clay_brick", "" }
	},
})

minetest.register_craftitem(":flowers:cotton", {
    description = "Cotton",
    image = "cotton.png",
})

minetest.register_craft({
    output = "flowers:cotton 3",
    recipe ={
	{"flowers:flower_cotton"},
    }
})

enabled_flowers = true
