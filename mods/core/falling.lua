spawn_falling_node = function(a,b) end

function nodeupdate_single(p)
	n = minetest.env:get_node(p)
	if minetest.get_node_group(n.name, "falling_node") ~= 0 then
		p_bottom = {x=p.x, y=p.y-1, z=p.z}
		n_bottom = minetest.env:get_node(p_bottom)
		-- Note: walkable is in the node definition, not in item groups
		if minetest.registered_nodes[n_bottom.name] and
				not minetest.registered_nodes[n_bottom.name].walkable then
			minetest.env:remove_node(p)
			spawn_falling_node(p, n.name)
			nodeupdate(p)
		end
	end
	if minetest.get_node_group(n.name, "dropping_node") ~= 0 then
		p_bottom = {x=p.x, y=p.y-1, z=p.z}
		n_bottom = minetest.env:get_node(p_bottom)
		if not minetest.registered_nodes[n_bottom.name].walkable and n_bottom.name ~= n.name then
			if not minetest.registered_nodes[n.name].drop_on_dropping then
				minetest.env:dig_node(p)
			else
				minetest.env:remove_node(p)
				local stack = ItemStack(minetest.registered_nodes[n.name].drop_on_dropping)
				for i = 1,stack:get_count() do
					local obj = minetest.env:add_item(p, stack:get_name())
					local x = math.random(-5,5)
					local z = math.random(-5,5)
					obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
				end
			end
			nodeupdate(p)
		end
	end
end

function nodeupdate(p)
	for x = -1,1 do
		for y = -1,1 do
			for z = -1,1 do
				p2 = {x=p.x+x, y=p.y+y, z=p.z+z}
				nodeupdate_single(p2)
			end
		end
	end
end