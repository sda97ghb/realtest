farming = {}
realtest.registered_crops = {}
realtest.registered_crops_list = {}
function realtest.register_crop(name, CropDef)
	local crop = {
		name = name,
		description = CropDef.description or "Crop",
		stages = CropDef.stages or 8,
		grow_light = CropDef.grow_light or 8,
		grow_interval = CropDef.grow_interval or 40,
		grow_chance = CropDef.grow_chance or 20,
		gen_sheaf = true
	}
	if CropDef.gen_sheaf == false then
		crop.gen_sheaf = false
	end
	realtest.registered_crops[name] = crop
	table.insert(realtest.registered_crops_list,name)
	local nnames = {}
	local name_ = name:get_modname_prefix().."_"..name:remove_modname_prefix()
	for j = 1,crop.stages do
		local drop
		if j == 8 then
			drop = name.."_sheaf"
		else
			drop = {
				max_items = 1,
				items = {
					{
						items = {},
						rarity = 2,
					},
					{
						items = {name.."_seeds"},
					}
				}
			}
		end
		minetest.register_node(name.."_stage_"..j, {
			description = crop.description,
			tiles = {name_.."_"..j..".png"},
			groups = {cracky=3, dig_immediate=3, not_in_creative_inventory=1, grow_stage=j, dropping_node=1},
			drop = drop,
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			drawtype = "nodebox",
			paramtype = "light",
			sunlight_propagates = true,
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5,-0.5,-0.3,0.5,0.5,-0.3},
					{-0.5,-0.5, 0.3,0.5,0.5, 0.3},
					{-0.3,-0.5,-0.5,-0.3,0.5,0.5},
					{ 0.3,-0.5,-0.5, 0.3,0.5,0.5},
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {
					{-0.5,-0.5,-0.5,0.5,-0.5+j/10,0.5},
				},
			}
		})
		if j ~= crop.stages then
			table.insert(nnames, name.."_stage_"..j)
		end
	end
	
	minetest.register_craftitem(name.."_seeds", {
		description = crop.description.." Seeds",
		inventory_image = name_.."_seeds.png",
		on_place = function(itemstack, placer, pointed_thing)
			minetest.item_place(ItemStack(name.."_stage_1"), placer, pointed_thing)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
	
	if crop.gen_sheaf then
		minetest.register_craftitem(name.."_sheaf", {
			description = crop.description.." Sheaf",
			inventory_image = name_.."_sheaf.png",
		})
	end
	
	minetest.register_abm({
		nodenames = nnames,
		interval = crop.grow_interval,
		chance = crop.grow_chance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			if not minetest.env:get_node_light(pos) or
				minetest.env:get_node_light(pos) < crop.grow_light then
				return
			end
			if minetest.get_node_group(minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name, "farm") == 1 then
				local stage = minetest.get_node_group(node.name, "grow_stage")
				minetest.env:set_node(pos, {name=name.."_stage_"..stage+1})
			end
		end,
	})
end

realtest.register_crop("farming:wheat_hard", {
	description = "Hard Wheat"
})

realtest.register_crop("farming:wheat_soft", {
	description = "Soft Wheat"
})

realtest.register_crop("farming:rye", {
	description = "Rye"
})

realtest.register_crop("farming:rice", {
	description = "Rice"
})

realtest.register_crop("farming:oat", {
	description = "Oat"
})

realtest.register_crop("farming:barley", {
	description = "Barley"
})

-- Tomato

realtest.register_crop("farming:tomato", {
	description = "Tomato",
	gen_sheaf = false,
})

local TomatoDef = minetest.registered_nodes["farming:tomato_stage_8"]
TomatoDef.drop = {
	max_items = 1,
	items = {
		{
			rarity = 2,
			items = {"farming:tomato 4"},
		},
		{
			items = {"farming:tomato 3"},
		}
	}
}
minetest.register_node(":farming:tomato_stage_8", TomatoDef)

minetest.register_craftitem("farming:tomato", {
	description = "Tomato",
	inventory_image = "farming_tomato.png"
})

minetest.register_craft({
	recipe = {{"farming:tomato"}},
	output = "farming:tomato_seeds"
})

-- Tomato end

farming.grains = {
	"wheat_hard",
	"wheat_soft",
	"rye",
	"rice",
	"oat",
	"barley",--[[
	"maize",
	"millet",
	"siberian_millet",
	"panic",
	"payza",
	"dagussa",
	"buckwheat",
	"teff",
	"rape",]]
}
--[[
farming.legumes = {
	"peas",
	"beans",
	"soy_beans",
	"vetch",
	"lentils",
	"beans",
	"peanuts",
	"lupins",
	"chick",
	"bamboo",
	"sugar_cane",
}

farming.nuts = {
	"walnuts",
	"black_walnut",
	"manchurian",
	"pecan",
	"filberts",
	"hazelnuts",
	"chestnuts",
	"acorns",
	"beech",
	"almonds",
	"pistachios",
	"cashew_nuts",
	"cedar",
	"coconut",
}]]