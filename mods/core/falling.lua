function minetest.register_node(name, nodedef)
	nodedef.type = "node"
	if not nodedef.cause_drop then
		nodedef.cause_drop = function(pos, node)
			local b_pos = {x=pos.x,y=pos.y-1,z=pos.z}
			local b_node = minetest.env:get_node(b_pos)
			if minetest.registered_nodes[b_node.name].falling_node_walkable == false or
				minetest.registered_nodes[b_node.name].buildable_to then
				return true
			end
		end
	end
	if not nodedef.cause_fall then
		nodedef.cause_fall = function(pos, node)
			local b_pos = {x=pos.x,y=pos.y-1,z=pos.z}
			local b_node = minetest.env:get_node(b_pos)
			if minetest.registered_nodes[b_node.name].falling_node_walkable == false or
				minetest.registered_nodes[b_node.name].buildable_to then
				return true
			end
		end
	end
	if nodedef.falling_node_walkable == nil then
		nodedef.falling_node_walkable = true
	end
	minetest.register_item(name, nodedef)
end

realtest.registered_on_updatenodes = {}
function realtest.register_on_updatenode(func)
	table.insert(realtest.registered_on_updatenodes, func)
end
minetest.register_on_updatenode = realtest.register_on_updatenode

function nodeupdate_single(pos)
	for _, callback in ipairs(realtest.registered_on_updatenodes) do
		local node = minetest.env:get_node(pos)
		callback(pos, node)
	end
end

function nodeupdate(pos)
	for x = -1,1 do
		for y = -1,1 do
			for z = -1,1 do
				pos2 = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
				nodeupdate_single(pos2)
			end
		end
	end
end

realtest.register_on_updatenode(function(pos, node)
	if minetest.get_node_group(node.name, "dropping_node") ~= 0 then
		if minetest.registered_nodes[node.name].cause_drop(pos, node) then
			local meta = minetest.env:get_meta(pos)
			if minetest.registered_nodes[node.name].on_dropping then
				minetest.registered_nodes[node.name].on_dropping(pos, node)
			else
				local drops = minetest.registered_nodes[node.name].drop_on_dropping or
					minetest.registered_nodes[node.name].drop or node.name
				if type(drops) == "string" then drops = {drops} end
				minetest.env:remove_node(pos)
				minetest.handle_node_drops(pos, drops)
			end
			if minetest.registered_nodes[node.name].after_dig_node then
				minetest.registered_nodes[node.name].after_dig_node(pos, node, meta, nil)
			end
			nodeupdate(pos)
		end
	end
end)

realtest.register_on_updatenode(function(pos, node)
		local b_node = minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z})
		if minetest.get_node_group(node.name, "dropping_like_stone") ~= 0 and
				(minetest.registered_nodes[b_node.name].walkable == false or
					minetest.registered_nodes[b_node.name].buildable_to) then
			local sides = {{x=-1,y=0,z=0}, {x=1,y=0,z=0}, {x=0,y=0,z=-1}, {x=0,y=0,z=1}, {x=0,y=-1,z=0}, {x=0,y=1,z=0}}
			local drop = true
			for _, s in ipairs(sides) do
				if  minetest.get_node_group(minetest.env:get_node({x=pos.x+s.x,y=pos.y+s.y,z=pos.z+s.z}).name, "dropping_like_stone") ~= 0 then
					drop = false
					break
				end
			end
			if drop then
				minetest.env:remove_node({x=pos.x,y=pos.y,z=pos.z})
				minetest.handle_node_drops(pos, {node.name})
				nodeupdate(pos)
			end
		end
	end)

realtest.register_on_updatenode(function(pos, node)
	if minetest.get_node_group(node.name, "falling_node") ~= 0 then
		if minetest.registered_nodes[node.name].cause_fall(pos, node) then
			if minetest.registered_nodes[node.name].on_falling then
				minetest.registered_nodes[node.name].on_falling(pos, node)
			else
				minetest.env:remove_node(pos)
				spawn_falling_node(pos, node.name)
			end
			nodeupdate(pos)
		end
	end
end)

realtest.register_on_updatenode(function(pos, node)
	if minetest.get_node_group(node.name, "attached_node") ~= 0 then
		local function check_attached_node(p, n)
			local def = minetest.registered_nodes[n.name]
			local d = {x=0, y=0, z=0}
			if def.paramtype2 == "wallmounted" then
				if n.param2 == 0 then
					d.y = 1
				elseif n.param2 == 1 then
					d.y = -1
				elseif n.param2 == 2 then
					d.x = 1
				elseif n.param2 == 3 then
					d.x = -1
				elseif n.param2 == 4 then
					d.z = 1
				elseif n.param2 == 5 then
					d.z = -1
				end
			else
				d.y = -1
			end
			local p2 = {x=p.x+d.x, y=p.y+d.y, z=p.z+d.z}
			local nn = minetest.env:get_node(p2).name
			local def2 = minetest.registered_nodes[nn]
			if def2 and (not def2.walkable or def2.buildable_to) then
				return false
			end
			return true
		end
		if not check_attached_node(pos, node) then
			minetest.env:remove_node(pos)
			minetest.handle_node_drops(pos, minetest.get_node_drops(node.name, nil))
			nodeupdate(pos)
		end
	end
end)

minetest.register_entity(":__builtin:falling_node", {
	initial_properties = {
		physical = true,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
		visual = "wielditem",
		textures = {},
		visual_size = {x=0.667, y=0.667},
	},

	nodename = "",

	set_node = function(self, nodename)
		self.nodename = nodename
		local stack = ItemStack(nodename)
		local itemtable = stack:to_table()
		local itemname = nil
		if itemtable then
			itemname = stack:to_table().name
		end
		local item_texture = nil
		local item_type = ""
		if minetest.registered_items[itemname] then
			item_texture = minetest.registered_items[itemname].inventory_image
			item_type = minetest.registered_items[itemname].type
		end
		prop = {
			is_visible = true,
			textures = {nodename},
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		return self.nodename
	end,

	on_activate = function(self, staticdata)
		self.nodename = staticdata
		self.object:set_armor_groups({immortal=1})
		--self.object:setacceleration({x=0, y=-10, z=0})
		self:set_node(self.nodename)
	end,

	on_step = function(self, dtime)
		-- Set gravity
		self.object:setacceleration({x=0, y=-10, z=0})
		-- Turn to actual sand when collides to ground or just move
		local pos = self.object:getpos()
		local bcp = {x=pos.x, y=pos.y-0.7, z=pos.z} -- Position of bottom center point
		local bcn = minetest.env:get_node(bcp)
		-- Note: walkable is in the node definition, not in item groups
		if minetest.registered_nodes[bcn.name] and
				minetest.registered_nodes[bcn.name].falling_node_walkable then
			if minetest.registered_nodes[bcn.name].buildable_to then
				minetest.env:remove_node(bcp)
				return
			end
			local np = {x=bcp.x, y=bcp.y+1, z=bcp.z}
			-- Check what's here
			local n2 = minetest.env:get_node(np)
			-- If it's not air or liquid, remove node and replace it with
			-- it's drops
			if n2.name ~= "air" and (not minetest.registered_nodes[n2.name] or
					minetest.registered_nodes[n2.name].liquidtype == "none") then
				local drops = minetest.get_node_drops(n2.name, "")
				minetest.env:remove_node(np)
				-- Add dropped items
				local _, dropped_item
				for _, dropped_item in ipairs(drops) do
					minetest.env:add_item(np, dropped_item)
				end
				-- Run script hook
				local _, callback
				for _, callback in ipairs(minetest.registered_on_dignodes) do
					callback(np, n2, nil)
				end
			end
			-- Create node and remove entity
			minetest.env:add_node(np, {name=self.nodename})
			self.object:remove()
			nodeupdate(np)
		else
			-- Do nothing
		end
	end
})