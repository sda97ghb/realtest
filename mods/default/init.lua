-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 14

-- Definitions made by this mod that other mods can use too
default = {}
realtest = {}

-- Load other files
dofile(minetest.get_modpath("default").."/player.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")

--
-- Tool definition
--

-- The hand
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={[2]=2.00, [3]=1.00}, uses=0, maxlevel=1},
			crumbly = {times={[2]=7.50, [3]=5.00}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3},
		}
	}
})

--
-- Crafting definition
--

minetest.register_craft({
	output = "default:sandstone",
	recipe = {
		{"default:sand", "default:sand"},
		{"default:sand", "default:sand"},
	}
})

minetest.register_craft({
	output = "default:clay",
	recipe = {
		{"default:clay_lump", "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump"},
	}
})

minetest.register_craft({
	output = "default:brick",
	recipe = {
		{"default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick"},
	}
})

minetest.register_craft({
	output = "default:paper",
	recipe = {
		{"default:papyrus", "default:papyrus", "default:papyrus"},
	}
})

minetest.register_craft({
	output = "default:book",
	recipe = {
		{"default:paper"},
		{"default:paper"},
		{"default:paper"},
	}
})

--
-- Crafting (tool repair)
--
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})

--
-- Cooking recipes
--

minetest.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "default:sand",
})

minetest.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "default:desert_sand",
})

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "default:clay_lump",
})

--
-- Fuels
--

minetest.register_craft({
	type = "fuel",
	recipe = "default:cactus",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:papyrus",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bookshelf",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_wood",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:ladder",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:torch",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:sign_wall",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest_locked",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coal_lump",
	burntime = 30,
})

--
-- Node definitions
--

-- Default node sounds

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=1.0}
	table.dug = table.dug or
			{name="default_dug_node", gain=1.0}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.2}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=0.5}
	--table.dug = table.dug or
	--		{name="default_dirt_break", gain=0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_grass_footstep", gain=0.25}
	--table.dug = table.dug or
	--		{name="default_dirt_break", gain=0.25}
	table.dug = table.dug or
			{name="", gain=0.25}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.3}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_grass_footstep", gain=0.25}
	table.dig = table.dig or
			{name="default_dig_crumbly", gain=0.4}
	table.dug = table.dug or
			{name="", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_stone_footstep", gain=0.25}
	table.dug = table.dug or
			{name="default_break_glass", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

--

minetest.register_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	particle_image = {"default_cobble.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"default:cobble", "minerals:borax"},
				rarity = 50,
			},
			{
				items = {"default:cobble", "default:cobble", "default:cobble"},
				rarity = 5
			},
			{
				items = {"default:cobble", "default:cobble"}
			},
			{
				items = {"default:cobble"},
				rarity = 5
			},
		},
	},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:desert_stone", {
	description = "Desert Stone",
	tiles = {"default_desert_stone.png"},
	particle_image = {"default_desert_stone.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_flat", {
	description = "Flat Stone",
	tiles = {"default_stone_flat.png"},
	particle_image = {"default_stone_flat.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:desert_stone_flat", {
	description = "Desert Flat Stone",
	tiles = {"default_desert_stone_flat.png"},
	particle_image = {"default_desert_stone_flat.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:cobbleblock_flat", {
	description = "Stone Brick Block",
	tiles = {"default_cobbleblock_flat.png"},
	particle_image = {"default_cobble.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
	particle_image = {"default_dirt.png"},
	is_ground_content = true,
	groups = {crumbly=3,drop_on_dig=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.4},
	}),
})

minetest.register_node("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	particle_image = {"default_dirt.png"},
	is_ground_content = true,
	groups = {crumbly=3,drop_on_dig=1, falling_node=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	particle_image = {"default_sand.png"},
	is_ground_content = true,
	groups = {crumbly=3, falling_node=1,drop_on_dig=1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:desert_sand", {
	description = "Desert Sand",
	tiles = {"default_desert_sand.png"},
	particle_image = {"default_desert_sand.png"},
	is_ground_content = true,
	groups = {sand=1, crumbly=3, falling_node=1,drop_on_dig=1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	particle_image = {"default_gravel.png"},
	is_ground_content = true,
	groups = {crumbly=2, falling_node=1,drop_on_dig=1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.45},
	}),
})

minetest.register_node("default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	particle_image = {"default_sandstone.png"},
	is_ground_content = true,
	groups = {crumbly=2,cracky=2,drop_on_dig=1},
	drop = "default:sand",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sand_with_clay", {
	description = "Clay",
	tiles = {"default_sand.png^default_clay.png"},
	particle_image = {"default_clay_lump.png"},
	is_ground_content = true,
	groups = {crumbly=3,drop_on_dig=1},
	drop = "default:clay_lump 4",
	sounds = default.node_sound_dirt_defaults({
		footstep = "",
	}),
})

minetest.register_node("default:dirt_with_clay", {
	description = "Clay",
	tiles = {"default_dirt.png^default_clay.png"},
	particle_image = {"default_clay_lump.png"},
	is_ground_content = true,
	groups = {crumbly=3, drop_on_dig=1},
	drop = "default:clay_lump 4",
	sounds = default.node_sound_dirt_defaults({
		footstep = "",
	}),
})

minetest.register_node("default:dirt_with_grass_and_clay", {
	description = "Clay",
	tiles = {"default_grass.png", "default_dirt.png^default_clay.png", "default_dirt.png^default_clay.png^default_grass_side.png"},
	particle_image = {"default_clay_lump.png"},
	is_ground_content = true,
	groups = {crumbly=3, drop_on_dig=1},
	drop = "default:clay_lump 4",
	sounds = default.node_sound_dirt_defaults({
		footstep = "",
	}),
})


minetest.register_node("default:brick", {
	description = "Brick Block",
	tiles = {"default_brick.png"},
	particle_image = {"default_clay_brick.png"},
	is_ground_content = true,
	groups = {cracky=3,drop_on_dig=1},
	drop = "default:clay_brick 4",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:cactus", {
	description = "Cactus",
	tiles = {"default_cactus_top.png", "default_cactus_top.png", "default_cactus_side.png"},
	groups = {snappy=2,choppy=3,flammable=2,dropping_node=1,drop_on_dig=1},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
		},
	},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:papyrus", {
	description = "Papyrus",
	drawtype = "plantlike",
	tiles = {"default_papyrus.png"},
	particle_image = {"default_papyrus.png"},
	inventory_image = "default_papyrus.png",
	wield_image = "default_papyrus.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	groups = {snappy=3,flammable=2, dropping_node=1,drop_on_dig=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:glass", {
	description = "Glass",
	drawtype = "glasslike",
	tiles = {"default_glass.png"},
	inventory_image = minetest.inventorycube("default_glass.png"),
	particle_image = {"default_glass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:rail", {
	description = "Rail",
	drawtype = "raillike",
	tiles = {"default_rail.png", "default_rail_curved.png", "default_rail_t_junction.png", "default_rail_crossing.png"},
	particle_image = {"default_rail.png"},
	inventory_image = "default_rail.png",
	wield_image = "default_rail.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
                -- but how to specify the dimensions for curved and sideways rails?
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,snappy=1,dig_immediate=2},
})

minetest.register_node("default:water_flowing", {
	description = "Flowing Water",
	inventory_image = minetest.inventorycube("default_water.png"),
	drawtype = "flowingliquid",
	tiles = {"default_water.png"},
	special_tiles = {
		{
			image="default_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
		{
			image="default_water_flowing_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = WATER_VISC,
	post_effect_color = {a=64, r=100, g=100, b=200},
	groups = {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1},
})

minetest.register_node("default:water_source", {
	description = "Water Source",
	inventory_image = minetest.inventorycube("default_water.png"),
	drawtype = "liquid",
	tiles = {
		{name="default_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{name="default_water.png", backface_culling=false},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = WATER_VISC,
	post_effect_color = {a=64, r=100, g=100, b=200},
	groups = {water=3, liquid=3, puts_out_fire=1},
})

minetest.register_node("default:lava_flowing", {
	description = "Flowing Lava",
	inventory_image = minetest.inventorycube("default_lava.png"),
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			image="default_lava_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
		},
		{
			image="default_lava_flowing_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
		},
	},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = LAVA_VISC,
	damage_per_second = 4*2,
	post_effect_color = {a=192, r=255, g=64, b=0},
	groups = {lava=3, liquid=2, hot=3, igniter=1, not_in_creative_inventory=1},
})

minetest.register_node("default:lava_source", {
	description = "Lava Source",
	inventory_image = minetest.inventorycube("default_lava.png"),
	drawtype = "liquid",
	tiles = {
		{name="default_lava_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{name="default_lava.png", backface_culling=false},
	},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = LAVA_VISC,
	damage_per_second = 4*2,
	post_effect_color = {a=192, r=255, g=64, b=0},
	groups = {lava=3, liquid=2, hot=3, igniter=1},
})

minetest.register_node("default:torch", {
	description = "Torch",
	drawtype = "torchlike",
	--tiles = {"default_torch_on_floor.png", "default_torch_on_ceiling.png", "default_torch.png"},
	tiles = {
		{name="default_torch_on_floor_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="default_torch_on_ceiling_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="default_torch_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = LIGHT_MAX-1,
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
	},
	groups = {choppy=2,dig_immediate=3,flammable=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("default:sign_wall", {
	description = "Sign",
	drawtype = "signlike",
	tiles = {"default_sign_wall.png"},
	inventory_image = "default_sign_wall.png",
	wield_image = "default_sign_wall.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = <default>
		--wall_bottom = <default>
		--wall_side = <default>
	},
	groups = {choppy=2,dig_immediate=2},
	sounds = default.node_sound_defaults(),
	on_construct = function(pos)
		--local n = minetest.env:get_node(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", "hack:sign_text_input")
		meta:set_string("infotext", "\"\"")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		--print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
		local meta = minetest.env:get_meta(pos)
		fields.text = fields.text or ""
		print((sender:get_player_name() or "").." wrote \""..fields.text..
				"\" to sign at "..minetest.pos_to_string(pos))
		meta:set_string("text", fields.text)
		meta:set_string("infotext", "\""..fields.text.."\"")
	end,
})

minetest.register_node("default:chest", {
	description = "Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})

local function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

minetest.register_node("default:chest_locked", {
	description = "Locked Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_lock.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locked Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from locked chest at "..minetest.pos_to_string(pos))
	end,
})

minetest.register_node("default:cobbleblock", {
	description = "Block of Cobble",
	tiles = {"default_cobbleblock.png"},
	particle_image = {"default_cobble.png"},
	is_ground_content = true,
	drop = "default:cobble 9",
	groups = {crumbly=2, oddly_breakable_by_hand=1, falling_node=1, drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("default:cobble", {
	description = "Stone",
	inventory_image = "default_cobble.png",
})

minetest.register_node("default:cobble_node", {
	description = "Stone",
	tiles = {"default_stone.png"},
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
	drop = "default:cobble",
	groups = {dig_immediate=2,dropping_node=1,drop_on_dig=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "default:cobbleblock",
	recipe = {
		{"default:cobble","default:cobble","default:cobble"},
		{"default:cobble","default:cobble","default:cobble"},
		{"default:cobble","default:cobble","default:cobble"},
	},
})

minetest.register_node("default:dry_shrub", {
	description = "Dry Shrub",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_dry_shrub.png"},
	inventory_image = "default_dry_shrub.png",
	particle_image = {"default_dry_shrub.png"},
	wield_image = "default_dry_shrub.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=3,flammable=3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/3, -1/2, -1/3, 1/3, 1/6, 1/3},
	},
})

--
-- Crafting items
--

minetest.register_craftitem("default:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
})

minetest.register_craftitem("default:book", {
	description = "Book",
	inventory_image = "default_book.png",
})

minetest.register_craftitem("default:coal_lump", {
	description = "Charcoal",
	inventory_image = "default_charcoal.png",
})

minetest.register_craftitem("default:clay_lump", {
	description = "Clay Lump",
	inventory_image = "default_clay_lump.png",
})

minetest.register_craftitem("default:clay_brick", {
	description = "Clay Brick",
	inventory_image = "default_clay_brick.png",
})

--
-- Some common functions
--

function nodeupdate_single(p)
	n = minetest.env:get_node(p)
	if minetest.get_node_group(n.name, "falling_node") ~= 0 then
		p_bottom = {x=p.x, y=p.y-1, z=p.z}
		n_bottom = minetest.env:get_node(p_bottom)
		-- Note: walkable is in the node definition, not in item groups
		if minetest.registered_nodes[n_bottom.name] and
				not minetest.registered_nodes[n_bottom.name].walkable then
			minetest.env:remove_node(p)
			spawn_falling_node(p, n.name)
			nodeupdate(p)
		end
	end
	if minetest.get_node_group(n.name, "dropping_node") ~= 0 then
		p_bottom = {x=p.x, y=p.y-1, z=p.z}
		n_bottom = minetest.env:get_node(p_bottom)
		if not minetest.registered_nodes[n_bottom.name].walkable and n_bottom.name ~= n.name then
			if not minetest.registered_nodes[n.name].drop_on_dropping then
				minetest.env:dig_node(p)
			else
				minetest.env:remove_node(p)
				local stack = ItemStack(minetest.registered_nodes[n.name].drop_on_dropping)
				for i = 1,stack:get_count() do
					local obj = minetest.env:add_item(p, stack:get_name())
					local x = math.random(-5,5)
					local z = math.random(-5,5)
					obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
				end
			end
			nodeupdate(p)
		end
	end
end

function nodeupdate(p)
	for x = -1,1 do
	for y = -1,1 do
	for z = -1,1 do
		p2 = {x=p.x+x, y=p.y+y, z=p.z+z}
		nodeupdate_single(p2)
	end
	end
	end
end

--
-- Global callbacks
--

-- Global environment step function
function on_step(dtime)
	-- print("on_step")
end
minetest.register_globalstep(on_step)

function on_placenode(p, node)
	--print("on_placenode")
end
minetest.register_on_placenode(on_placenode)

function on_dignode(p, node)
	--print("on_dignode")
end
minetest.register_on_dignode(on_dignode)

function on_punchnode(p, node)
end
minetest.register_on_punchnode(on_punchnode)

-- END

minetest.register_on_dignode(function(pos, oldnode, digger)
	local sides = {{x=-1,y=0,z=0}, {x=1,y=0,z=0}, {x=0,y=0,z=-1}, {x=0,y=0,z=1}, {x=0,y=-1,z=0}, {x=0,y=1,z=0},}
	for _, s in ipairs(sides) do
		if minetest.env:get_node({x=pos.x+s.x,y=pos.y+s.y,z=pos.z+s.z}).name == "default:stone" then
			local fall = true
			for _2, s2 in ipairs(sides) do
				if minetest.env:get_node({x=pos.x+s.x+s2.x,y=pos.y+s.y+s2.y,z=pos.z+s.z+s2.z}).name ~= "air" then
					fall = false
					break
				end
			end
			if fall then
				minetest.env:remove_node({x=pos.x+s.x,y=pos.y+s.y,z=pos.z+s.z})
				minetest.env:add_item({x=pos.x+s.x,y=pos.y+s.y,z=pos.z+s.z}, "default:stone")
			end
		end
	end
end)

minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	interval = 2,
	chance = 200,
	action = function(pos, node)
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
			minetest.env:set_node(pos, {name="default:dirt"})
			nodeupdate_single(pos)
		end
	end
})

minetest.register_abm({
	nodenames = {"default:dirt_with_clay"},
	interval = 2,
	chance = 200,
	action = function(pos, node)
		pos.y = pos.y+1
		local n = minetest.registered_nodes[minetest.env:get_node(pos).name]
		if not n then
			return
		end
		if not n.sunlight_propagates then
			return
		end
		if n.liquidtype and n.liquidtype ~= "none" then
			return
		end
		if not minetest.env:get_node_light(pos) then
			return
		end
		if minetest.env:get_node_light(pos) < 13 then
			return
		end
		pos.y = pos.y-1
		minetest.env:set_node(pos, {name="default:dirt_with_grass_and_clay"})
	end
})

minetest.register_abm({
 	nodenames = {"default:dirt_with_grass_and_clay"},
	interval = 2,
	chance = 200,
	action = function(pos, node)
		pos.y = pos.y+1
		local n = minetest.registered_nodes[minetest.env:get_node(pos).name]
		if not n then
			return
		end
		if not n.sunlight_propagates or (n.liquidtype and n.liquidtype ~= "none") then
			pos.y = pos.y-1
			minetest.env:set_node(pos, {name="default:dirt_with_clay"})
		end
	end
})
