farming = {}
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
farming.grains_desc = {
	"Hard Wheat",
	"Soft Wheat",
	"Rye",
	"Rice",
	"Oat",
	"Barley",
	"Maize",
	"Millet",
	"Siberian Millet",
	"Panic",
	"Payza",
	"Dagussa",
	"Buckwheat",
	"Teff",
	"Rape",
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

farming.other = {
	"cotton"
}

farming.other_desc = {
	"Cotton"
}

for i, grain in ipairs(farming.grains) do
	local nnames = {}
	for j = 1,8 do
		local drop
		if j == 8 then
			drop = "farming:"..grain.."_sheaf"
		else
			drop = {
				max_items = 1,
				items = {
					{
						items = {},
						rarity = 2,
					},
					{
						items = {"farming:"..grain.."_seeds"},
					}
				}
			}
		end
		minetest.register_node("farming:"..grain.."_stage_"..j, {
			description = farming.grains_desc[i],
			tiles = {"farming_"..grain.."_"..j..".png"},
			groups = {cracky=3, dig_immediate=3, not_in_creative_inventory=1, grow_stage=j},
			drop = drop,
			sounds = default.node_sound_leaves_defaults(),
			walkable = false,
			drawtype = "nodebox",
			paramtype = "light",
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
			},
			on_construct = function(pos)
				local meta = minetest.env:get_meta(pos)
				meta:set_int("progress",j*10)
			end,
		})
		if j ~= 8 then
			table.insert(nnames, "farming:"..grain.."_stage_"..j)
		end
	end
	
	minetest.register_craftitem("farming:"..grain.."_seeds", {
		description = farming.grains_desc[i].." Seeds",
		inventory_image = "farming_"..grain.."_seeds.png",
		on_place = function(itemstack, placer, pointed_thing)
			minetest.item_place(ItemStack("farming:"..grain.."_stage_1"), placer, pointed_thing)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
	
	minetest.register_craftitem("farming:"..grain.."_sheaf", {
		description = farming.grains_desc[i].." Sheaf",
		inventory_image = "farming_"..grain.."_sheaf.png",
	})
	
	minetest.register_abm({
		nodenames = nnames,
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			if not minetest.env:get_node_light(pos) or
				minetest.env:get_node_light(pos) < 8 then
				return
			end
			local grounds = {
				"default:dirt",
				"default:dirt_with_clay",
				"default:dirt_with_grass",
				"default:dirt_with_grass_and_clay"
			}
			if table.contains(grounds, minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name) then
				local stage = minetest.get_node_group(node.name, "grow_stage")
				minetest.env:set_node(pos, {name="farming:"..grain.."_stage_"..stage+1})
			end
		end,
	})
end
