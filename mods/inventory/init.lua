minetest.register_on_joinplayer(function(player)
	player:set_inventory_formspec("size[8,7.5]"..
			"image[1.5,0.6;1,2;player.png]"..
			"list[current_player;main;0,3.5;8,4;]"..
			"list[current_player;craft;4,0.5;2,2;]"..
			"list[current_player;craftpreview;7,1;1,1;]")
	--[[player:on_metadata_inventory_take() = function(pos, listname, index, stack, player)
		if listname == "craftpreview" then
			local n
			for i = 1,4 do
				local inv = player:get_inventory()
				local s = inv:get_stack("craft", i)
				if minetest.get_item_group(s:get_name(), "axe") == 1 then
					s:add_wear(65535/minetest.get_item_group(s:get_name(), "durability"))
					inv:set_stack(stack)
				end
				break
			end
		end
	end]]
end)
