joiner_table = {}
realtest.registered_joiner_table_recipes = {}

function realtest.register_joiner_table_recipe(RecipeDef)
	local recipe = {
		item1 = RecipeDef.item1 or "",
		item2 = RecipeDef.item2 or "",
		rmitem1 = RecipeDef.rmitem1,
		rmitem2 = RecipeDef.rmitem2,
		output = RecipeDef.output or "",
		instrument = RecipeDef.instrument or "saw",
	}
	if recipe.rmitem1 == nil then
		recipe.rmitem1 = true
	end
	if recipe.rmitem2 == nil then
		recipe.rmitem2 = true
	end
	if recipe.output ~= "" and recipe.item1 ~= "" then
		table.insert(realtest.registered_joiner_table_recipes, recipe)
	end
end

for _, tree in pairs(realtest.registered_trees_list) do
	realtest.register_joiner_table_recipe({
		item1 = tree.."_log",
		output = tree.."_plank 4"
	})
	realtest.register_joiner_table_recipe({
		item1 = tree.."_plank",
		output = tree.."_stick 4"
	})
end

realtest.register_joiner_table_recipe({
	item1 = "default:stone",
	output = "default:stone_flat",
	instrument = "chisel"
})

realtest.register_joiner_table_recipe({
	item1 = "default:desert_stone",
	output = "default:desert_stone_flat",
	instrument = "chisel"
})

for _, tree in pairs(realtest.registered_trees) do
	local planks = tree.textures.planks
	minetest.register_node("joiner_table:joiner_table_"..tree.name:remove_modname_prefix(),
	{
		description = tree.description .. " Joiner Table",
		tiles = {planks.."^joiner_table_top.png", planks, planks.."^joiner_table_side.png",
				planks.."^joiner_table_side.png", planks.."^joiner_table_side.png", planks.."^joiner_table_face.png"},
		groups = {oddly_breakable_by_hand=3, dig_immediate=2},
		sounds = default.node_sound_wood_defaults(),
		paramtype = "light",
		paramtype2 = "facedir",
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", "size[8,8]"..
					"button[0.5,0.25;1.35,1;buttonCraft;Craft]"..
					"button[1.6,0.25;0.9,1;buttonCraft10;x10]"..
					"list[current_name;src1;3.9,0.75;1,1;]"..
					"image[4.69,0.72;0.54,1.5;anvil_arrow.png]"..
					"list[current_name;src2;5.1,0.75;1,1;]"..
					"list[current_name;instruments;0.5,1.5;2,2;]"..
					"list[current_name;output;4.5,2;1,1;]"..
					"list[current_player;main;0,4;8,4;]")
			meta:set_string("infotext", "Joiner Table")
			local inv = meta:get_inventory()
			inv:set_size("src1", 1)
			inv:set_size("src2", 1)
			inv:set_size("instruments", 4)
			inv:set_size("output", 1)
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
	
			local src1, src2 = inv:get_stack("src1", 1), inv:get_stack("src2", 1)
			local output = inv:get_stack("output", 1)
			
			local find_instrument = function(instrument)
				for i = 1, 4 do
					local istack = inv:get_stack("instruments", i)
					if minetest.get_node_group(istack:get_name(), instrument) == 1 then
						return i
					end
				end
				return nil
			end
			
			local craft = function()
				for _, recipe in ipairs(realtest.registered_joiner_table_recipes) do
					local instr = find_instrument(recipe.instrument)
					local instr_stack = nil
					if instr then
						instr_stack = inv:get_stack("instruments", instr)
					end
					if instr_stack and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() then
						minetest.chat_send_all("sdf")
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
							instr_stack:add_wear(65535/minetest.get_item_group(instr_stack:get_name(), "durability"))
							inv:set_stack("instruments", instr, instr_stack)
						end
						return
					end
				end
			end
			
			if fields["buttonCraft"] then
				craft()
			elseif fields["buttonCraft10"] then
				for i = 0, 9 do
					craft()
				end
			end
		end,
	})
	minetest.register_craft({
		output = "joiner_table:joiner_table_"..tree.name:remove_modname_prefix(),
		recipe = {
			{tree.name.."_planks", tree.name.."_planks"},
			{tree.name.."_planks", tree.name.."_planks"}
		}
	})
end
