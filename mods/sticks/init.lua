minetest.register_tool("sticks:sticks", {
	description = "Sticks",
	inventory_image = "default_sticks.png",
	on_use = function(item, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		if minetest.env:get_node(pointed_thing.above).name == "air" then
			local objects = minetest.env:get_objects_inside_radius(pointed_thing.above, 0.5)
			local pos = pointed_thing.above
			local bonfireb = 0
			local furnaceb = 0
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
							v:remove()
						end
					end
			end
			if furnaceb >= 9 and furnace.check_furnace_blocks(pos) then
				minetest.env:set_node(pos, {name = "furnace:self"})
			elseif bonfireb >= 10 then
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
