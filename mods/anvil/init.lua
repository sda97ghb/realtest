anvil = {}
realtest.registered_anvil_recipes = {}

function realtest.register_anvil_recipe(RecipeDef)
	local recipe = {
		type = RecipeDef.type or "forge",
		item1 = RecipeDef.item1 or "",
		item2 = RecipeDef.item2 or "",
		rmitem1 = RecipeDef.rmitem1,
		rmitem2 = RecipeDef.rmitem2,
		output = RecipeDef.output or "",
		level = RecipeDef.level or 0,
	}
	if recipe.rmitem1 == nil then
		recipe.rmitem1 = true
	end
	if recipe.rmitem2 == nil then
		recipe.rmitem2 = true
	end
	if recipe.level < 0 then
		recipe.level = 0
	end
	if recipe.output ~= "" and recipe.item1 ~= "" and (recipe.type == "forge" or recipe.type == "weld") then
		table.insert(realtest.registered_anvil_recipes, recipe)
	end
end

--Unshaped metals, buckets, double ingots, sheets and hammers
for i, metal in ipairs(metals.list) do
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_unshaped",
		output = "metals:"..metal.."_ingot",
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_sheet",
		item2 = "metals:recipe_bucket",
		rmitem2 = false,
		output = "metals:bucket_empty_"..metal,
		level = metals.levels[i],
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doubleingot",
		output = "metals:"..metal.."_sheet",
		level = metals.levels[i] - 1,
	})
	realtest.register_anvil_recipe({
		type = "weld",
		item1 = "metals:"..metal.."_ingot",
		item2 = "metals:"..metal.."_ingot",
		output = "metals:"..metal.."_doubleingot",
		level = metals.levels[i] - 1,
	})
	realtest.register_anvil_recipe({
		type = "weld",
		item1 = "metals:"..metal.."_sheet",
		item2 = "metals:"..metal.."_sheet",
		output = "metals:"..metal.."_doublesheet",
		level = metals.levels[i] - 1,
	})
end
--Pig iron --> Wrought iron
realtest.register_anvil_recipe({
	item1 = "metals:pig_iron_ingot",
	output = "metals:wrought_iron_ingot",
	level = 3,
})
--Instruments
local instruments = 
	{{"axe", "_ingot"}, 
	 {"pick", "_ingot"},
	 {"shovel", "_ingot"},
	 {"spear", "_ingot"},
	 {"sword", "_doubleingot"},
	 {"hammer", "_doubleingot"}
	}
for _, instrument in ipairs(instruments) do
	for i, metal in ipairs(metals.list) do
		realtest.register_anvil_recipe({
			item1 = "metals:"..metal..instrument[2],
			item2 = "metals:recipe_"..instrument[1],
			rmitem2 = false,
			output = "metals:tool_"..instrument[1].."_"..metal.."_head",
			level = metals.levels[i],
		})
	end
end

minetest.register_craft({
	output = 'anvil:stone_anvil',
	recipe = {
		{'default:stone','default:stone','default:stone'},
		{'','default:stone',''},
		{'default:stone','default:stone','default:stone'},
	}
})

local anvils = {
	{'stone', 'Stone', 0, 61*2.3},
	{'copper', 'Copper', 1, 411*2.3},
	{'rose_gold', 'Rose Gold', 2, 521*2.3},
	{'bismuth_bronze', 'Bismuth Bronze', 2, 581*2.3},
	{'black_bronze', 'Black Bronze', 2, 531*2.3},
	{'bronze', 'Bronze', 2, 601*2.3},
	{'wrought_iron', 'Wrought Iron', 3, 801*2.3},
	{'steel', 'Steel', 4, 1101*2.3},
	{'black_steel', 'Black Steel', 5, 1501*2.3}
}

for _, anvil in ipairs(anvils) do
	if anvil[1] ~= "stone" then
		minetest.register_craft({
			output = "anvil:"..anvil[1].."_anvil",
			recipe = {
				{"metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot"},
				{"","metals:"..anvil[1].."_doubleingot",""},
				{"metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot"},
			}
		})
	end
end

for i = 1, 2 do
	for _, anvil in ipairs(anvils) do
		local postfix = ""
		local ttiles = {"anvil_"..anvil[1].."_top.png","anvil_"..anvil[1].."_top.png","anvil_"..anvil[1].."_side.png"}
		if i == 2 then 
			ttiles = {"anvil_"..anvil[1].."_top.png^anvil_cracked.png","anvil_"..anvil[1].."_top.png^anvil_cracked.png",
				"anvil_"..anvil[1].."_side.png^anvil_cracked.png"}
			postfix = "_cracked"
		end
		minetest.register_node("anvil:"..anvil[1].."_anvil"..postfix, {
			description = anvil[2] .. " Anvil",
			tiles = ttiles,
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
					{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
					{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
					{-0.35,-0.1,-0.2,0.35,0.1,0.2},
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {
					{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
					{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
					{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
					{-0.35,-0.1,-0.2,0.35,0.1,0.2},
				},
			},
			groups = {oddly_breakable_by_hand=2, cracky=3, dig_immediate=1},
			sounds = default.node_sound_stone_defaults(),
			can_dig = function(pos,player)
				local meta = minetest.env:get_meta(pos);
				local inv = meta:get_inventory()
				if inv:is_empty("src1") and inv:is_empty("src2") and inv:is_empty("hammer")
					and inv:is_empty("output") and inv:is_empty("flux") then
					return true
				end
				return false
			end,
			on_construct = function(pos)
				local meta = minetest.env:get_meta(pos)
				meta:set_string("formspec", "invsize[8,7;]"..
						"button[0.5,0.25;2,1;buttonForge;Forge]"..
						"list[current_name;src1;2.9,0.25;1,1;]"..
						"image[3.69,0.22;0.54,1.5;anvil_arrow.png]"..
						"list[current_name;src2;4.1,0.25;1,1;]"..
						"button[5.5,0.25;2,1;buttonWeld;Weld]"..
						"list[current_name;hammer;1,1.5;1,1;]"..
						"list[current_name;output;3.5,1.5;1,1;]"..
						"list[current_name;flux;6,1.5;1,1;]"..
						"list[current_player;main;0,3;8,4;]")
				meta:set_string("infotext", anvil[2].." Anvil")
				if i == 1 then
					meta:set_int("durability", anvil[4])
				else
					meta:set_int("durability", anvil[4]/4)
				end
				meta:set_int("max_durability", anvil[4])
				local inv = meta:get_inventory()
				inv:set_size("src1", 1)
				inv:set_size("src2", 1)
				inv:set_size("hammer", 1)
				inv:set_size("output", 1)
				inv:set_size("flux", 1)
			end,
			on_receive_fields = function(pos, formname, fields, sender)
				local meta = minetest.env:get_meta(pos)
				local inv = meta:get_inventory()
		
				local src1, src2 = inv:get_stack("src1", 1), inv:get_stack("src2", 1)
				local hammer, flux = inv:get_stack("hammer", 1), inv:get_stack("flux", 1)
				local output = inv:get_stack("output", 1)
				if string.sub(hammer:get_name(), 12, 17) == "hammer" then
					if fields["buttonForge"] then
						for _, recipe in ipairs(realtest.registered_anvil_recipes) do
							if recipe.type == "forge" and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() and
								anvil[3] >= recipe.level and
								minetest.registered_items[hammer:get_name()].groups["material_level"] >= recipe.level then
								if inv:room_for_item("output", recipe.output) then
									if recipe.rmitem1 then
										src1:take_item()
										inv:set_stack("src1", 1, src1)
									end
									if recipe.item2 ~= "" and recipe.rmitem2 then
										src2:take_item()
										inv:set_stack("src2", 1, src2)
									end
									output:add_item(recipe.output)
									inv:set_stack("output", 1, output)
									hammer:add_wear(65535/30)
									inv:set_stack("hammer", 1, hammer)
									meta:set_int("durability", meta:get_int("durability") - 1)
									if i == 1 and meta:get_int("durability") / meta:get_int("max_durability") <= 1/4 then
										hacky_swap_node(pos, "anvil:"..anvil[1].."_anvil_cracked")
										minetest.sound_play("default_dug_node",	{pos = pos})
									end
									if meta:get_int("durability") <= 0 then
										for _, name in ipairs({"src1", "src2", "hammer", "output", "flux"}) do
											if not inv:is_empty(name) then
												minetest.env:add_item(pos, 
												{name=inv:get_stack(name, 1):get_name(),
												 count=inv:get_stack(name, 1):get_count(),
												 wear=inv:get_stack(name, 1):get_wear(),
												 metadata=inv:get_stack(name, 1):get_metadata()})
											end
										end
										minetest.env:remove_node(pos)
										minetest.sound_play("default_dug_node",	{pos = pos})
									end
								end
								return
							end
						end 
					elseif fields["buttonWeld"] then
						if flux:get_name() == "minerals:flux" then
							for _, recipe in ipairs(realtest.registered_anvil_recipes) do
								if recipe.type == "weld" and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() and
							 		anvil[3] >= recipe.level and
							 		minetest.registered_items[hammer:get_name()].groups["material_level"] >= recipe.level then
									if inv:room_for_item("output", recipe.output) then
										if recipe.rmitem1 then
											src1:take_item()
											inv:set_stack("src1", 1, src1)
										end
										if recipe.item2 ~= "" and recipe.rmitem2 then
											src2:take_item()
											inv:set_stack("src2", 1, src2)
										end
										output:add_item(recipe.output)
										inv:set_stack("output", 1, output)
										flux:take_item()
										inv:set_stack("flux", 1, flux)
										hammer:add_wear(65535/60)
										inv:set_stack("hammer", 1, hammer)
										meta:set_int("durability", meta:get_int("durability") - 1)
										if i == 1 and meta:get_int("durability") / meta:get_int("max_durability") <= 1/4 then
											hacky_swap_node(pos, "anvil:"..anvil[1].."_anvil_cracked")
											minetest.sound_play("default_dug_node",	{pos = pos})
										end
										if meta:get_int("durability") <= 0 then
											for _, name in ipairs({"src1", "src2", "hammer", "output", "flux"}) do
												if not inv:is_empty(name) then
													minetest.env:add_item(pos, 
												{name=inv:get_stack(name, 1):get_name(),
												 count=inv:get_stack(name, 1):get_count(),
												 wear=inv:get_stack(name, 1):get_wear(),
												 metadata=inv:get_stack(name, 1):get_metadata()})
												end
											end
											minetest.env:remove_node(pos)
											minetest.sound_play("default_dug_node",	{pos = pos})
										end
									end
									return
								end
							end 
						end
					end
				end
			end,
		})
	end
end
