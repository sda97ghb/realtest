realtest.registered_dirts = {}
realtest.registered_dirts_list = {}

function realtest.register_dirt(name, DirtRef)
	local dirt = {
		name = name,
		description = DirtRef.description or "Dirt",
		grass = true,
		clay = true,
		farm = true
	}
	if DirtRef.grass == false then
		dirt.grass = false
	end
	if DirtRef.clay == false then
		dirt.clay = false
	end
	if DirtRef.farm == false then
		dirt.farm = false
	end
	realtest.registered_dirts[name] = dirt
	table.insert(realtest.registered_dirts_list, name)
	
	local name_ = name:get_modname_prefix().."_"..name:remove_modname_prefix()
	
	local nograss_grass = {
		[name] = name.."_with_grass",
		[name.."_farm"] = name.."_farm_with_grass",
		[name.."_with_clay"] = name.."_with_grass_and_clay",
		[name.."_farm_with_clay"] = name.."_farm_with_grass_and_clay",
	}
	
	local grass_nograss = {
		[name.."_with_grass"] = name,
		[name.."_farm_with_grass"] = name.."_farm",
		[name.."_with_grass_and_clay"] = name.."_with_clay",
		[name.."_farm_with_grass_and_clay"] = name.."_farm_with_clay",
	}
	
	local farm_nofarm = {
		[name.."_farm"] = name,
		[name.."_farm_with_grass"] = name.."_with_grass",
		[name.."_farm_with_clay"] = name.."_with_clay",
		[name.."_farm_with_grass_and_clay"] = name.."_with_grass_and_clay"
	}
	
	
	minetest.register_node(":"..name, {
		description = dirt.description,
		tiles = {name_..".png"},
		particle_image = {name_..".png"},
		groups = {crumbly=3,drop_on_dig=1, falling_node=1, dirt=1},
		sounds = default.node_sound_dirt_defaults(),
	})
	
	if dirt.grass then
		minetest.register_node(":"..name .. "_with_grass", {
			description = dirt.description .. " with Grass",
			tiles = {name_.."_grass.png", name_..".png", name_.."_grass.png"},
			particle_image = {name_..".png"},
			groups = {crumbly=3,drop_on_dig=1,dirt=1,grass=1},
			drop = name,
			sounds = default.node_sound_dirt_defaults({
				footstep = {name="default_grass_footstep", gain=0.4},
			}),
		})
	end
	
	if dirt.clay then
		minetest.register_node(":"..name.."_with_clay", {
			description = dirt.description .. " with Clay",
			tiles = {name_..".png^grounds_clay.png"},
			particle_image = {"grounds_clay_lump.png"},
			groups = {crumbly=3, drop_on_dig=1, dirt=1,clay=1, falling_node=1},
			drop = "grounds:clay_lump 4",
			sounds = default.node_sound_dirt_defaults(),
		})
	end
	
	if dirt.farm then
		minetest.register_node(":"..name.."_farm", {
			description = "Farm " .. dirt.description,
			tiles = {name_.."_farm.png", name_..".png", name_..".png"},
			particle_image = {name_..".png"},
			drop = name,
			groups = {crumbly=3,drop_on_dig=1, falling_node=1, dirt=1, farm=1},
			sounds = default.node_sound_dirt_defaults(),
			on_falling = function(pos, node)
				minetest.env:set_node(pos, {name = farm_nofarm[node.name]})
				nodeupdate_single(pos)
			end,
		})
	end
	
	if dirt.grass and dirt.clay then
		minetest.register_node(":"..name.."_with_grass_and_clay", {
			description = dirt.description .. " with Grass and Clay",
			tiles = {name_.."_grass.png", name_..".png^grounds_clay.png", name_.."_grass.png"},
			particle_image = {"grounds_clay_lump.png"},
			groups = {crumbly=3, drop_on_dig=1, dirt=1, grass=1, clay=1},
			drop = "grounds:clay_lump 4",
			sounds = default.node_sound_dirt_defaults({
				footstep = {name="default_grass_footstep", gain=0.4},
			}),
		})
	end
	
	if dirt.farm and dirt.grass then
		minetest.register_node(":"..name.."_farm_with_grass", {
			description = "Farm " .. dirt.description .. " with Grass",
			tiles = {name_.."_farm.png", name_..".png", name_.."_grass.png"},
			particle_image = {name_..".png"},
			drop = name,
			groups = {crumbly=3,drop_on_dig=1, dirt=1, grass=1, farm=1},
			sounds = default.node_sound_dirt_defaults(),
			on_falling = function(pos, node)
				minetest.env:set_node(pos, {name = farm_nofarm[node.name]})
				nodeupdate_single(pos)
			end,
		})
	end
	
	if dirt.farm and dirt.clay then
		minetest.register_node(":"..name.."_farm_with_clay", {
			description = "Farm " .. dirt.description .. " with Clay",
			tiles = {name_.."_farm.png",name_..".png^grounds_clay.png",name_..".png^grounds_clay.png"},
			particle_image = {"grounds_clay_lump.png"},
			groups = {crumbly=3, drop_on_dig=1, dirt=1, farm=1, clay=1, falling_node=1},
			drop = "grounds:clay_lump 4",
			sounds = default.node_sound_dirt_defaults(),
			on_falling = function(pos, node)
				minetest.env:set_node(pos, {name = farm_nofarm[node.name]})
				nodeupdate_single(pos)
			end,
		})
	end
	
	if dirt.farm and dirt.grass and dirt.clay then
		minetest.register_node(":"..name.."_farm_with_grass_and_clay", {
			description = "Farm " .. dirt.description .. " with Grass and Clay",
			tiles = {name_.."_farm.png", name_..".png^grounds_clay.png", name_.."_grass.png"},
			particle_image = {"grounds_clay_lump.png"},
			groups = {crumbly=3, drop_on_dig=1, dirt=1, farm=1, grass=1, clay=1},
			drop = "grounds:clay_lump 4",
			sounds = default.node_sound_dirt_defaults({
				footstep = {name="default_grass_footstep", gain=0.4},
			}),
			on_falling = function(pos, node)
				minetest.env:set_node(pos, {name = farm_nofarm[node.name]})
				nodeupdate_single(pos)
			end,
		})
	end

	minetest.register_abm({
		nodenames = {name, name.."_farm", name.."_with_clay", name.."_farm_with_clay"},
		interval = 200,
		chance = 30,
		action = function(pos, node)
			pos.y = pos.y+1
			local n = minetest.registered_nodes[minetest.env:get_node(pos).name]
			if not n then
				return
			end
			if not n.sunlight_propagates then
				return
			end
			if n.liquidtype and n.liquidtype ~= "none" then
				return
			end
			if not minetest.env:get_node_light(pos) then
				return
			end
			if minetest.env:get_node_light(pos) < 13 then
				return
			end
			pos.y = pos.y-1
			minetest.env:set_node(pos, {name=nograss_grass[node.name]})
		end
	})
	
	minetest.register_abm({
		nodenames = {name.."_with_grass", name.."_farm_with_grass", name.."_with_grass_and_clay", name.."_farm_with_grass_and_clay"},
		interval = 200,
		chance = 30,
		action = function(pos, node)
			pos.y = pos.y+1
			local n = minetest.registered_nodes[minetest.env:get_node(pos).name]
			if not n then
				return
			end
			if (n.liquidtype and n.liquidtype ~= "none") then
				pos.y = pos.y-1
				minetest.env:set_node(pos, {name=grass_nograss[node.name]})
				nodeupdate_single(pos)
			end
		end
	})
	
	minetest.register_abm({
		nodenames = {name.."_farm", name.."_farm_with_grass", name.."_farm_with_clay", name.."_farm_with_grass_and_clay"},
		interval = 1,
		chance = 2,
		action = function(pos, node)
			if node then
				if not minetest.registered_nodes[minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name].buildable_to then
					minetest.env:set_node(pos, {name = farm_nofarm[node.name]})
					return
				end
			end
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y+1,z=pos.z}, 1)
			for k, obj in pairs(objs) do
				if obj:is_player() then
					minetest.env:set_node(pos, {name = farm_nofarm[node.name]})
					return
				end
			end
		end,
	})
	
	minetest.register_abm({
		nodenames = {name.."_with_grass", name.."_farm_with_grass", name.."_with_grass_and_clay", name.."_farm_with_grass_and_clay"},
		interval = 17,
		chance = 5,
		action = function(pos, node)
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y+1,z=pos.z}, 1)
			for k, obj in pairs(objs) do
				if obj:is_player() then
					if minetest.registered_nodes[minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name].buildable_to then
						minetest.env:set_node(pos, {name=grass_nograss[node.name]})
						nodeupdate_single(pos)
						return
					end
				end
			end
		end,
	})
end

realtest.register_dirt("default:dirt", {description = "Dirt"})
