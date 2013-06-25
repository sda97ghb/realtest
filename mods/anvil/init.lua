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
		instrument = RecipeDef.instrument or "hammer"
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

--Unshaped metals, buckets, double ingots, sheets, hammers, locks and hatches
for i, metal in ipairs(metals.list) do
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_unshaped",
		output = "metals:"..metal.."_ingot",
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_sheet",
		item2 = "scribing_table:plan_bucket",
		rmitem2 = false,
		output = "instruments:bucket_"..metal,
		level = metals.levels[i],
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doubleingot",
		output = "metals:"..metal.."_sheet",
		level = metals.levels[i] - 1,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doubleingot",
		output = "metals:"..metal.."_ingot 2",
		level = metals.levels[i] - 1,
		instrument = "chisel"
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doublesheet",
		output = "metals:"..metal.."_sheet 2",
		level = metals.levels[i] - 1,
		instrument = "chisel"
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
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_ingot",
		item2 = "scribing_table:plan_lock",
		rmitem2 = false,
		output = "metals:"..metal.."_lock",
		level = metals.levels[i]
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_ingot",
		item2 = "scribing_table:plan_hatch",
		rmitem2 = false,
		output = "hatches:"..metal.."_hatch_closed",
		level = metals.levels[i]
	})
	realtest.register_anvil_recipe({
		item1 = "minerals:borax",
		output = "minerals:flux 8"
	})
	realtest.register_anvil_recipe({
		item1 = "minerals:sylvite",
		output = "minerals:flux 4"
	})
end
--Pig iron --> Wrought iron
realtest.register_anvil_recipe({
	item1 = "metals:pig_iron_ingot",
	output = "metals:wrought_iron_ingot",
	level = 2,
})
--Instruments
local instruments = 
	{{"axe", "_ingot"}, 
	 {"pick", "_ingot"},
	 {"shovel", "_ingot"},
	 {"spear", "_ingot"},
	 {"chisel", "_ingot"},
	 {"sword", "_doubleingot"},
	 {"hammer", "_doubleingot"},
	 {"saw", "_sheet"}
	}
for _, instrument in ipairs(instruments) do
	for i, metal in ipairs(metals.list) do
		-- the proper way to do that is to check whether we have metal in instruments.metals list or not
		-- but who cares?
		local output_name = "instruments:"..instrument[1].."_"..metal.."_head"
		if minetest.registered_items[output_name] then
			realtest.register_anvil_recipe({
				item1 = "metals:"..metal..instrument[2],
				item2 = "scribing_table:plan_"..instrument[1],
				rmitem2 = false,
				output = output_name,
				level = metals.levels[i],
			})
		end
	end
end

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

minetest.register_craft({
	output = 'anvil:anvil_stone',
	recipe = {
		{'default:stone','default:stone','default:stone'},
		{'','default:stone',''},
		{'default:stone','default:stone','default:stone'},
	}
})

for _, anvil in ipairs(anvils) do
	if anvil[1] ~= "stone" then
		minetest.register_craft({
			output = "anvil:anvil_"..anvil[1],
			recipe = {
				{"metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot"},
				{"","metals:"..anvil[1].."_doubleingot",""},
				{"metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot"},
			}
		})
	end
end

for _, anvil in ipairs(anvils) do
	minetest.register_node("anvil:anvil_"..anvil[1], {
		description = anvil[2] .. " Anvil",
		tiles = {"anvil_"..anvil[1].."_top.png","anvil_"..anvil[1].."_top.png","anvil_"..anvil[1].."_side.png"},
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
		groups = {oddly_breakable_by_hand=2, dig_immediate=1},
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
			meta:set_string("formspec", "size[8,7]"..
					"button[0.5,0.25;1.35,1;buttonForge;Forge]"..
					"button[1.6,0.25;0.9,1;buttonForge10;x10]"..
					"list[current_name;src1;2.9,0.25;1,1;]"..
					"image[3.69,0.22;0.54,1.5;anvil_arrow.png]"..
					"list[current_name;src2;4.1,0.25;1,1;]"..
					"button[5.5,0.25;1.35,1;buttonWeld;Weld]"..
					"button[6.6,0.25;0.9,1;buttonWeld10;x10]"..
					"list[current_name;hammer;1,1.5;1,1;]"..
					"list[current_name;output;3.5,1.5;1,1;]"..
					"list[current_name;flux;6,1.5;1,1;]"..
					"list[current_player;main;0,3;8,4;]")
			meta:set_string("infotext", anvil[2].." Anvil")
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
			local instrument, flux = inv:get_stack("hammer", 1), inv:get_stack("flux", 1)
			local output = inv:get_stack("output", 1)
			local forge = function()
				for _, recipe in ipairs(realtest.registered_anvil_recipes) do
					if recipe.type == "forge" and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() and
						anvil[3] >= recipe.level and
						minetest.get_item_group(instrument:get_name(),  recipe.instrument) == 1 and
						minetest.get_item_group(instrument:get_name(), "material_level") >= recipe.level - 1 then
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
							instrument:add_wear(65535/minetest.get_item_group(instrument:get_name(), "durability"))
							inv:set_stack("hammer", 1, instrument)
						end
						return
					end
				end
			end
			local weld = function()
				if flux:get_name() == "minerals:flux" then
					for _, recipe in ipairs(realtest.registered_anvil_recipes) do
						if recipe.type == "weld" and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() and
							anvil[3] >= recipe.level and
							minetest.get_item_group(instrument:get_name(),  recipe.instrument) == 1 and
							minetest.get_item_group(instrument:get_name(), "material_level") >= recipe.level then
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
								instrument:add_wear(65535/minetest.get_item_group(instrument:get_name(), "durability")/2)
								inv:set_stack("hammer", 1, instrument)
							end
							return
						end
					end 
				end
			end
			if fields["buttonForge"] then
				forge()
			elseif fields["buttonForge10"] then
				for i = 0, 9 do
					forge()
				end
			elseif fields["buttonWeld"] then
				weld()
			elseif fields["buttonWeld10"] then
				for i = 0, 9 do
					weld()
				end
			end
		end,
	})
end
