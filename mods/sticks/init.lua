minetest.register_tool("sticks:sticks", {
	description = "Sticks",
	inventory_image = "default_sticks.png",
	on_use = function(item, user, pointed_thing)
		local pos
		if pointed_thing.type == "node" then	
			if minetest.env:get_node(pointed_thing.under).name == "furnace:self" then
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
			for _, v in ipairs(objects) do
					if not v:is_player() and v:get_luaentity() and v:get_luaentity().name == "__builtin:item" then
						local istack = ItemStack(v:get_luaentity().itemstring)
						if istack:get_name() == "default:stick" then
							bonfireb = bonfireb + istack:get_count() * 2
							v:remove()
						elseif istack:get_name() == "default:leaves" then
							bonfireb = bonfireb + istack:get_count()
							v:remove()
						elseif istack:get_name() == "default:coal_lump" then
							furnaceb = furnaceb + istack:get_count()
							table.insert(coals,v)
						end
					end
			end
			if furnaceb >= 9 then
				if furnace.check_furnace_blocks(pos) then
					for _, v in ipairs(coals) do
						v:remove()
					end
					minetest.env:set_node(pos, {name = "furnace:self"})
					if furnaceb > 9 then
						local meta = minetest.env:get_meta(pos)
						local inv = meta:get_inventory()
						inv:add_item("fuel", "default:coal_lump "..furnaceb-9)
					end
				end
			end
			if bonfireb >= 10 and minetest.env:get_node(pos).name == "air" then
				minetest.env:set_node(pos, {name = "bonfire:self"})
			end
		end
		item:add_wear(65535/10)
		return item
	end,
})


minetest.register_craft({
	output = "sticks:sticks",
	recipe = {
		{"", "default:stick"},
		{"default:stick", ""},
	},
})

minetest.register_alias("sticks", "sticks:sticks")
