function minetest.register_node(name, nodedef)
	nodedef.type = "node"
	if not nodedef.cause_drop then
		nodedef.cause_drop = function(pos, node)
			local b_pos = {x=pos.x,y=pos.y-1,z=pos.z}
			local b_node = minetest.env:get_node(b_pos)
			if minetest.registered_nodes[b_node.name].walkable == false or
				minetest.registered_nodes[b_node.name].buildable_to then
				return true
			end
		end
	end
	if not nodedef.cause_fall then
		nodedef.cause_fall = function(pos, node)
			local b_pos = {x=pos.x,y=pos.y-1,z=pos.z}
			local b_node = minetest.env:get_node(b_pos)
			if minetest.registered_nodes[b_node.name].walkable == false or
				minetest.registered_nodes[b_node.name].buildable_to then
				return true
			end
		end
	end
	minetest.register_item(name, nodedef)
end

function nodeupdate_single(p)
	n = minetest.env:get_node(p)
	if minetest.get_node_group(n.name, "falling_node") ~= 0 then
		if minetest.registered_nodes[n.name].cause_fall(p, n) then
			if minetest.registered_nodes[n.name].on_falling then
				minetest.registered_nodes[n.name].on_falling(p, n)
			else
				minetest.env:remove_node(p)
				spawn_falling_node(p, n.name)
			end
			nodeupdate(p)
		end
	end
	if minetest.get_node_group(n.name, "dropping_node") ~= 0 then
		if minetest.registered_nodes[n.name].cause_drop(p, n) then
			local meta = minetest.env:get_meta(p)
			if minetest.registered_nodes[n.name].on_dropping then
				minetest.registered_nodes[n.name].on_dropping(p, n)
			else
				local drops = minetest.registered_nodes[n.name].drop_on_dropping or
					minetest.registered_nodes[n.name].drop or n.name
				if type(drops) == "string" then drops = {drops} end
				minetest.env:remove_node(p)
				minetest.handle_node_drops(p, drops)
			end
			if minetest.registered_nodes[n.name].after_dig_node then
				minetest.registered_nodes[n.name].after_dig_node(p, n, meta, nil)
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