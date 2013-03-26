minetest.register_tool("sticks:sticks", {
	description = "Sticks",
	inventory_image = "sticks_sticks.png",
	on_use = function(item, user, pointed_thing)
		local pos
		if pointed_thing.type == "node" then	
			if minetest.env:get_node(pointed_thing.under).name == "furnace:self" or minetest.env:get_node(pointed_thing.under).name == "bonfire:self" or
				minetest.env:get_node(pointed_thing.under).name == "coke:bronze_furnace" then
				local meta = minetest.env:get_meta(pointed_thing.under)
				meta:set_int("active", 1)
				item:add_wear(65535/10)
				return item
			end
			pos = pointed_thing.above
		elseif pointed_thing.type == "object" then
			pos = pointed_thing.ref:getpos()
		else
			return
		end
		if minetest.env:get_node(pos).name == "air" then
			local objects = minetest.env:get_objects_inside_radius(pos, 0.5)
			local bonfireb = 0
			local furnaceb = 0
			local coals = {}
			local sticks_and_leaves = {}
			for _, v in ipairs(objects) do
					if not v:is_player() and v:get_luaentity() and v:get_luaentity().name == "__builtin:item" then
						local istack = ItemStack(v:get_luaentity().itemstring)
						if minetest.get_item_group(istack:get_name(), "stick") == 1 then
							bonfireb = bonfireb + istack:get_count() * 2
							table.insert(sticks_and_leaves,v)
						elseif minetest.get_item_group(istack:get_name(), "leaves") == 1  then
							bonfireb = bonfireb + istack:get_count()
							table.insert(sticks_and_leaves,v)
						elseif istack:get_name() == "default:coal_lump" then
							furnaceb = furnaceb + istack:get_count()
							table.insert(coals,v)
						end
					end
			end
			if furnaceb >= 9 and math.random(6) == 1 and minetest.env:get_node(pos).name == "air" then
				if furnace.check_furnace_blocks(pos) then
					for _, v in ipairs(coals) do
						v:remove()
					end
					minetest.env:set_node(pos, {name = "furnace:self_active"})
					local meta = minetest.env:get_meta(pos)
					meta:set_int("active", 1)
					meta:set_float("fuel_time", 0)
					meta:set_float("fuel_totaltime", 30)
					meta:set_string("formspec",
							"invsize[8,10;]"..
							"list[current_name;src1;1.5,0;1,1;]"..
							"list[current_name;dst1;1.5,1;1,1;]"..
							"list[current_name;src2;2.5,1;1,1;]"..
							"list[current_name;dst2;2.5,2;1,1;]"..
							"list[current_name;src3;3.5,2;1,1;]"..
							"list[current_name;dst3;3.5,3;1,1;]"..
							"list[current_name;src4;4.5,1;1,1;]"..
							"list[current_name;dst4;4.5,2;1,1;]"..
							"list[current_name;src5;5.5,0;1,1;]"..
							"list[current_name;dst5;5.5,1;1,1;]"..
							"image[3.5,4;1,1;default_furnace_fire_bg.png"..
								"^[lowpart:100:default_furnace_fire_fg.png]"..
							"list[current_name;fuel;3.5,5;1,1;]"..
							"list[current_player;main;0,6;8,4;]")
					if furnaceb > 9 then
						local inv = meta:get_inventory()
						inv:add_item("fuel", "default:coal_lump "..furnaceb-9)
					end
				end
			end
			if bonfireb >= 10 and math.random(2) == 1 and minetest.env:get_node(pos).name == "air" then
				for _, v in ipairs(sticks_and_leaves) do
					v:remove()
				end
				minetest.env:set_node(pos, {name = "bonfire:self"})
				local meta = minetest.env:get_meta(pos)
				meta:set_int("active", 1)
				meta:set_float("fuel_time", 0)
				meta:set_float("fuel_totaltime", 20)
				meta:set_string("formspec",
					"invsize[8,9;]"..
					"image[2,2;1,1;default_furnace_fire_bg.png"..
						"^[lowpart:100:default_furnace_fire_fg.png]"..
					"list[current_name;fuel;2,3;1,1;]"..
					"list[current_name;src;2,1;1,1;]"..
					"list[current_name;dst;5,1;2,1;]"..
					"list[current_player;main;0,5;8,4;]")
			end
		end
		item:add_wear(65535/10)
		return item
	end,
})


minetest.register_craft({
	type = "shapeless",
	output = "sticks:sticks",
	recipe = {"group:stick", "group:stick"},
})

minetest.register_alias("sticks", "sticks:sticks")
