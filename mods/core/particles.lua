minetest.register_entity("core:particle", {
	physical = true,
	collisionbox = {0,0,0,0,0,0},
	timer = 0,
	timer2 = 0,
	on_activate = function(self, staticdata)
		local obj = self.object
		obj:setacceleration({x=0, y=-5, z=0})
		local dx = (math.random(0,60)-30)/30
		local dy = (math.random(0,60))/30
		local dz = (math.random(0,60)-30)/30
		obj:setvelocity({x=dx, y=dy, z=dz})
		obj:setyaw(math.random(0,359)/180*math.pi)
		self.timer = math.random(0, 6)/3
	end,
	on_step = function(self, dtime)
		self.timer2 = self.timer2+dtime
		if self.timer2 >= 0.5 then
			if self.object:getvelocity().y == 0 then
				self.object:setvelocity({x=0, y=0, z=0})
			end
			self.timer2 = 0
		end
		self.timer = self.timer+dtime
		if self.timer >= 3 then
			self.object:remove()
		end
	end,
})

minetest.register_on_dignode(function(pos, oldnode, digger)
	local node = minetest.registered_nodes[oldnode.name]
	if not node or node.groups.no_particles or not digger then
		return
	end
	local tmp
	if digger ~= nil then
		tmp = minetest.get_node_drops(oldnode.name, digger:get_wielded_item():get_name())
	end
	if type(tmp) == "string" then
		node = minetest.registered_nodes[tmp]
	elseif type(tmp) == "table" and tmp[1] and tmp[1].get_name then
		node = minetest.registered_nodes[tmp[1]:get_name()]
	end
	if node == nil then
		node = minetest.registered_nodes[oldnode.name]
		-- prevent unwanted effects
		if node == nil then
			return
		end
	end
	for i=1,15 do
		if node.particle_image then
			local dx = (math.random(0,10)-5)/10
			local dy = (math.random(0,10)-5)/10
			local dz = (math.random(0,10)-5)/10
			
			local obj = minetest.env:add_entity({x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}, "core:particle")
			
			local vis_size = math.random(5,15)/100
			obj:set_properties({
				textures = node.particle_image,
				visual_size = {x=vis_size, y=vis_size},
			})
		end
		
	end
end)

minetest.register_entity("core:smoke", {
	physical = true,
	visual_size = {x=0.25, y=0.25},
	collisionbox = {0,0,0,0,0,0},
	visual = "sprite",
	textures = {"particles_smoke.png"},
	on_step = function(self, dtime)
		self.object:setacceleration({x=0, y=0.5, z=0})
		self.timer = self.timer + dtime
		if self.timer > 3 then
		self.object:remove()
		end
	end,
	timer = 0,
})

minetest.register_entity("core:fire", {
	physical = true,
	visual_size = {x=0.25, y=0.25},
	collisionbox = {0,0,0,0,0,0},
	visual = "sprite",
	textures = {"particles_fire.png"},
	on_step = function(self, dtime)
		self.object:setacceleration({x=0, y=0.2, z=0})
		self.timer = self.timer + dtime
		if self.timer > 2 then
			self.object:remove()
		end
	end,
	timer = 0,
})

minetest.register_abm({
	nodenames = {"group:fires"},
	interval = 0.5,
	chance = 1,
	action = function(pos)
		minetest.env:add_entity({x=pos.x+math.random(8)*0.1-0.4,y=pos.y-0.2+math.random()*0.25,z=pos.z+math.random(8)*0.1-0.4}, "core:fire")
		minetest.env:add_entity({x=pos.x+math.random(8)*0.1-0.4,y=pos.y-0.2+math.random()*0.25,z=pos.z+math.random(8)*0.1-0.4}, "core:fire")
		minetest.env:add_entity({x=pos.x+math.random(8)*0.1-0.4,y=pos.y-0.2+math.random()*0.25,z=pos.z+math.random(8)*0.1-0.4}, "core:fire")
	end,
})
