function minetest.handle_node_drops(pos, drops, digger)
	for _,item in ipairs(drops) do
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
				local x = math.random(1, 5)
				if math.random(1,2) == 1 then
					x = -x
				end
				local z = math.random(1, 5)
				if math.random(1,2) == 1 then
					z = -z
				end
				obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
			end
		end
	end
end

if minetest.setting_get("log_mods") then
	minetest.log("action", "item_drop loaded")
end
