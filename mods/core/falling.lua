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