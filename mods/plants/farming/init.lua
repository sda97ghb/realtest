farming = {}
realtest.registered_grains = {}
realtest.registered_grains_list = {}
function realtest.register_grain(name, GrainDef)
	local grain = {
		name = name,
		description = GrainDef.description or "Grain",
		stages = GrainDef.stages or 8,
		grounds = GrainDef.grounds or {"default:dirt", "default:dirt_with_grass", "default:dirt_with_clay", "default:dirt_with_grass_and_clay"},
		grow_light = GrainDef.grow_light or 8,
		grow_interval = GrainDef.grow_interval or 40,
		grow_chance = GrainDef.grow_chance or 20,
	}
	realtest.registered_grains[name] = grain
	table.insert(realtest.registered_grains_list,name)
	local nnames = {}
	local name_ = name:get_modname_prefix().."_"..name:remove_modname_prefix()
	for j = 1,grain.stages do
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
			description = grain.description,
			tiles = {name_.."_"..j..".png"},
			groups = {cracky=3, dig_immediate=3, not_in_creative_inventory=1, grow_stage=j},
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
		if j ~= grain.stages then
			table.insert(nnames, name.."_stage_"..j)
		end
	end
	
	minetest.register_craftitem(name.."_seeds", {
		description = grain.description.." Seeds",
		inventory_image = name_.."_seeds.png",
		on_place = function(itemstack, placer, pointed_thing)
			minetest.item_place(ItemStack(name.."_stage_1"), placer, pointed_thing)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
	
	minetest.register_craftitem(name.."_sheaf", {
		description = grain.description.." Sheaf",
		inventory_image = name_.."_sheaf.png",
	})
	
	minetest.register_abm({
		nodenames = nnames,
		interval = grain.grow_interval,
		chance = grain.grow_chance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			if not minetest.env:get_node_light(pos) or
				minetest.env:get_node_light(pos) < grain.grow_light then
				return
			end
			if table.contains(grounds, minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name) then
				local stage = minetest.get_node_group(node.name, "grow_stage")
				minetest.env:set_node(pos, {name=name.."_stage_"..stage+1})
			end
		end,
	})
end

realtest.register_grain("farming:wheat_hard", {
	description = "Hard Wheat"
})

realtest.register_grain("farming:wheat_soft", {
	description = "Soft Wheat"
})

realtest.register_grain("farming:rye", {
	description = "Rye"
})

realtest.register_grain("farming:rice", {
	description = "Rice"
})

realtest.register_grain("farming:oat", {
	description = "Oat"
})

realtest.register_grain("farming:barley", {
	description = "Barley"
})

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