--Mod by PilzAdam

function minetest.handle_node_drops(pos, drops, digger)
	local function drop(item)
		local count, name
		if type(item) == "string" then
			count = 1
			name = item
		else
			count = item:get_count()
			name = item:get_name()
		end
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
				minetest.after(3600, function(obj)
					obj:remove()
				end, obj)
			end
		end
	end
	local function drop_all()
		for _, item in ipairs(drops) do
			drop(item)
		end
	end
	if minetest.get_node_group(minetest.env:get_node(pos).name, "drop_on_dig") == 1 then
		drop_all()
	elseif digger:get_inventory() then
		for _, dropped_item in ipairs(drops) do
			if digger:get_inventory():room_for_item("main", dropped_item) then
				digger:get_inventory():add_item("main", dropped_item)
			else
				drop(dropped_item)
			end
		end
	end
end
