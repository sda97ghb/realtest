realtest.registered_stones = {}
realtest.registered_stones_list = {}

function realtest.register_stone(name, StoneRef)
	if not StoneRef then
		StoneRef = {}
	end
	local stone = {
		name = name,
		description = StoneRef.description or "Stone",
	}
	realtest.registered_stones[name] = stone
	table.insert(realtest.registered_stones_list, name)
	
	local name_ = name:get_modname_prefix().."_"..name:remove_modname_prefix()
	
	minetest.register_craftitem(":"..name.."_small_rock", {
		description = stone.description .. " Small Rock",
		inventory_image = name_.."_small_rock.png"
	})
	
	minetest.register_node(":"..name, {
		description = stone.description,
		tiles = {name_..".png"},
		particle_image = {name_.."_small_rock.png"},
		groups = {cracky=3, drop_on_dig=1, stone=1, dropping_like_stone=1},
		sounds = default.node_sound_stone_defaults(),
		drop = {
			max_items = 1,
			items = {
				{
					items = {name.."_small_rock"},
					rarity = 50,
				},
				{
					items = {name.."_small_rock", name.."_small_rock", name.."_small_rock"},
					rarity = 5
				},
				{
					items = {name.."_small_rock", name.."_small_rock"}
				},
				{
					items = {name.."_small_rock"},
					rarity = 5
				},
			}
		}
	})
	
	minetest.register_node(":"..name.."_flat", {
		description = "Flat "..stone.description,
		tiles = {name_.."_flat.png"},
		particle_image = {name_.."_small_rock.png"},
		groups = {cracky=3, drop_on_dig=1, stone=1, flat=1},
		sounds = default.node_sound_stone_defaults()
	})
	
	minetest.register_node(":"..name.."_bricks", {
		description = stone.description.." Bricks",
		tiles = {name_.."_bricks.png"},
		particle_image = {name_.."_small_rock.png"},
		groups = {cracky=3, drop_on_dig=1, stone=1, bricks=1},
		sounds = default.node_sound_stone_defaults()
	})
	
	minetest.register_node(":"..name.."_macadam", {
		description = stone.description.." Macadam",
		tiles = {name_.."_macadam.png"},
		particle_image = {name_.."_small_rock.png"},
		groups = {crumbly=2, drop_on_dig=1, stone=1, macadam=1, falling_node=1},
		sounds = default.node_sound_stone_defaults(),
		drop = name.."_small_rock 9"
	})
	
	minetest.register_craft({
		recipe = {
			{name.."_small_rock", name.."_small_rock", name.."_small_rock"},
			{name.."_small_rock", name.."_small_rock", name.."_small_rock"},
			{name.."_small_rock", name.."_small_rock", name.."_small_rock"}
		},
		output = name.."_macadam"
	})
	
	realtest.register_joiner_table_recipe({
		item1 = name,
		output = name.."_flat",
		instrument = "chisel"
	})
	
	realtest.register_joiner_table_recipe({
		item1 = name.."_slab",
		output = name.."_flat_slab",
		instrument = "chisel"
	})
	
	realtest.register_joiner_table_recipe({
		item1 = name.."_stair",
		output = name.."_flat_stair",
		instrument = "chisel"
	})
	
	realtest.register_joiner_table_recipe({
		item1 = name.."_flat",
		item2 = "scribing_table:stonebricks",
		output = name.."_bricks",
		rmitem2 = false,
		instrument = "chisel"
	})
	
	realtest.register_joiner_table_recipe({
		item1 = name.."_flat_slab",
		item2 = "scribing_table:stonebricks",
		output = name.."_bricks_slab",
		rmitem2 = false,
		instrument = "chisel"
	})
	
	realtest.register_joiner_table_recipe({
		item1 = name.."_flat_stair",
		item2 = "scribing_table:stonebricks",
		output = name.."_bricks_stair",
		rmitem2 = false,
		instrument = "chisel"
	})
	
	minetest.register_node(":"..name.."_small_rock_node", {
		tiles = {name_..".png"},
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
		drop = name.."_small_rock",
		groups = {dig_immediate=2,dropping_node=1,drop_on_dig=1},
		buildable_to = true,
		sounds = default.node_sound_stone_defaults(),
	})
	
	realtest.register_stair_and_slab(name)
	realtest.register_stair_and_slab(name.."_flat")
	realtest.register_stair_and_slab(name.."_bricks")
	
	instruments.chisel_pairs[name] = name.."_flat"
	instruments.chisel_pairs[name.."_slab"] = name.."_flat_slab"
	instruments.chisel_pairs[name.."_slab_r"] = name.."_flat_slab_r"
	instruments.chisel_pairs[name.."_stair"] = name.."_flat_stair"
	instruments.chisel_pairs[name.."_stair_r"] = name.."_flat_stair_r"
end

realtest.register_stone("default:stone")
realtest.register_stone("default:desert_stone", {description = "Desert Stone"})
minetest.register_node(":default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	particle_image = {"default_stone_small_rock.png"},
	groups = {cracky=3, drop_on_dig=1, stone=1, dropping_like_stone=1},
	sounds = default.node_sound_stone_defaults(),
	drop = {
		max_items = 1,
		items = {
			{
				items = {"default:stone_small_rock", "minerals:borax"},
				rarity = 50,
			},
			{
				items = {"default:stone_small_rock", "default:stone_small_rock", "default:stone_small_rock"},
				rarity = 5
			},
			{
				items = {"default:stone_small_rock", "default:stone_small_rock"}
			},
			{
				items = {"default:stone_small_rock"},
				rarity = 5
			},
		}
	}
})
