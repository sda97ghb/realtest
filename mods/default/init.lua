-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 14

-- Definitions made by this mod that other mods can use too
default = {}

-- Load other files
dofile(minetest.get_modpath("default").."/mapgen.lua")

--
-- Tool definition
--
if minetest.setting_getbool("creative_mode") then
	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = {x=1,y=1,z=2.5},
		tool_capabilities = {
			full_punch_interval = 0.5,
			max_drop_level = 3,
			groupcaps = {
				crumbly = {times={[1]=0.5, [2]=0.5, [3]=0.5}, uses=0, maxlevel=3},
				cracky = {times={[1]=0.5, [2]=0.5, [3]=0.5}, uses=0, maxlevel=3},
				snappy = {times={[1]=0.5, [2]=0.5, [3]=0.5}, uses=0, maxlevel=3},
				choppy = {times={[1]=0.5, [2]=0.5, [3]=0.5}, uses=0, maxlevel=3},
				oddly_breakable_by_hand = {times={[1]=0.5, [2]=0.5, [3]=0.5}, uses=0, maxlevel=3},
			}
		}
	})
	minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
		return true
	end)
else
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
				immediately_breakable_by_hand = {times={[2]=0.50, [3]=0.00}, uses=0, maxlevel=3},
				oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3},
			}
		}
	})
end

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
	recipe = "default:fence_wood",
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
			{name="default_hard_footstep", gain=0.25}
	table.dug = table.dug or
			{name="default_break_glass", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

minetest.register_node("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	particle_image = {"default_sand.png"},
	is_ground_content = true,
	groups = {crumbly=3, falling_node=1,drop_on_dig=1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:sand_with_clay", {
	description = "Clay",
	tiles = {"default_sand.png^default_clay.png"},
	particle_image = {"default_clay_lump.png"},
	is_ground_content = true,
	groups = {crumbly=3,drop_on_dig=1},
	drop = "grounds:clay_lump 4",
	sounds = default.node_sound_dirt_defaults({
		footstep = "",
	}),
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
			{-0.5, -0.5, 0.4, 0.5, 0.5, 0.4},
			{0.4, -0.5, -0.5, 0.4, 0.5, 0.5},
			{-0.5, -0.5, -0.4, 0.5, 0.5, -0.4},
			{-0.4, -0.5, -0.5, -0.4, 0.5, 0.5},
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

minetest.register_abm({
	nodenames = {"default:cactus"},
	interval = 60,
	chance = 30,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not minetest.env:get_node_light(pos) or
			minetest.env:get_node_light(pos) < 8 then
			return
		end
		local h = 1
		repeat
			if minetest.env:get_node({x=pos.x,y=pos.y-h,z=pos.z}).name == node.name then
				h = h + 1
			else
				break
			end
			if h > 2 then
				return
			end
		until h > 2
		local grounds = {
			"default:sand",
			"default:desert_sand",
			"default:dirt",
			"default:dirt_with_clay",
			"default:dirt_with_grass",
			"default:dirt_with_grass_and_clay"
		}
		if  minetest.registered_nodes[minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name].buildable_to
			and table.contains(grounds, minetest.env:get_node({x=pos.x,y=pos.y-h,z=pos.z}).name) then
			minetest.env:set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name=node.name})
		end
	end
})

minetest.register_abm({
	nodenames = {"default:cactus"},
    interval = 0.5,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
    players = minetest.env:get_objects_inside_radius(pos, 1)
	for i, player in ipairs(players) do
		player:set_hp(player:get_hp() - 1)
	end
	end,
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
	cause_drop = function(pos, node)
		local b_pos = {x=pos.x,y=pos.y-1,z=pos.z}
		local b_node = minetest.env:get_node(b_pos)
		if b_node.name ~= node.name and minetest.registered_nodes[b_node.name].walkable == false then
			return true
		end
	end
})

minetest.register_abm({
	nodenames = {"default:papyrus"},
	interval = 40,
	chance = 20,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not minetest.env:get_node_light(pos) or
			minetest.env:get_node_light(pos) < 8 then
			return
		end
		local h = 1
		repeat
			if minetest.env:get_node({x=pos.x,y=pos.y-h,z=pos.z}).name == node.name then
				h = h + 1
			else
				break
			end
			if h > 2 then
				return
			end
		until h > 2
		local sides = {{x=-1,y=-1,z=0},{x=1,y=-1,z=0},{x=0,y=-1,z=-1},{x=0,y=-1,z=1}}
		local water = false
		for _, side in ipairs(sides) do
			if minetest.env:get_node({x=pos.x+side.x,y=pos.y+side.y-h+1,z=pos.z+side.z}).name == "default:water_source" then
				water = true
				break
			end
		end
		local grounds = {
			"default:sand",
			"default:desert_sand",
			"default:dirt",
			"default:dirt_with_clay",
			"default:dirt_with_grass",
			"default:dirt_with_grass_and_clay"
		}
		if water and minetest.registered_nodes[minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name].buildable_to
			and table.contains(grounds, minetest.env:get_node({x=pos.x,y=pos.y-h,z=pos.z}).name) then
			minetest.env:set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name=node.name})
		end
	end
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
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3,drop_on_dig=1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:water_flowing", {
	description = "Flowing Water",
	inventory_image = minetest.inventorycube("default_water.png"),
	drawtype = "flowingliquid",
	tiles = {"default_water.png"},
	drop = "",
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
	drop = "",
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
	drop = "",
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
	drop = "",
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
	groups = {choppy=2,dig_immediate=3,flammable=1,attached_node=1},
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

minetest.register_craftitem("default:clay_brick", {
	description = "Clay Brick",
	inventory_image = "default_clay_brick.png",
})

realtest.register_stair_and_slab("default:glass")
realtest.register_stair_and_slab("default:stone")
realtest.register_stair_and_slab("default:stone_flat")
realtest.register_stair_and_slab("default:desert_stone")
realtest.register_stair_and_slab("default:desert_stone_flat")
realtest.register_stair_and_slab("default:cobbleblock_flat")
realtest.register_stair("default:brick",nil,nil,nil,"Brick Stair",nil,"default:clay_brick 3")
realtest.register_slab("default:brick",nil,nil,nil,"Brick Slab",nil,"default:clay_brick 2")
minetest.register_craft({
	output = "default:brick_slab",
	recipe = {
		{"default:clay_brick","default:clay_brick"},
	},
})
minetest.register_craft({
	output = "default:brick_stair",
	recipe = {
		{"default:clay_brick",""},
		{"default:clay_brick","default:clay_brick"},
	},
})
minetest.register_craft({
	output = "default:brick_stair",
	recipe = {
		{"","default:clay_brick"},
		{"default:clay_brick","default:clay_brick"},
	},
})

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