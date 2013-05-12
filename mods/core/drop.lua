if minetest.setting_getbool("creative_mode") then
	function minetest.handle_node_drops(pos, drops, digger)
		if not digger or not digger:is_player() then
			return
		end
		local inv = digger:get_inventory()
		if inv then
			for _,item in ipairs(drops) do
				item = ItemStack(item):get_name()
				if not inv:contains_item("main", item) then
					inv:add_item("main", item)
				end
			end
		end
	end
else
	function minetest.handle_node_drops(pos, drops, digger)
		local function drop(item)
			local count = ItemStack(item):get_count()
			local name = ItemStack(item):get_name()
			for i=1,count do
				local obj = minetest.env:add_item(pos, name)
				if obj ~= nil then
					obj:get_luaentity().collect = true
					local k = 1
					if name == "default:cobble" then
						k = math.random(3,6)
					end
					local x = math.random(1, 5)/k
					if math.random(1,2) == 1 then
						x = -x
					end
					local z = math.random(1, 5)/k
					if math.random(1,2) == 1 then
						z = -z
					end
					obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
				end
			end
		end
		local function drop_all()
			for _, item in ipairs(drops) do
				drop(item)
			end
		end
		if ALWAYS_DROP_NODES_AS_ITEMS and minetest.get_node_group(minetest.env:get_node(pos).name, "drop_on_dig") == 1 then
			drop_all()
		elseif digger and digger:get_inventory() then
			for _, dropped_item in ipairs(drops) do
				if digger:get_inventory():room_for_item("main", dropped_item) then
					digger:get_inventory():add_item("main", dropped_item)
				else
					drop(dropped_item)
				end
			end
		else
			drop_all()
		end
	end
end
