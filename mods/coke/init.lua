coke = {}

minetest.register_node("coke:bituminous_coal_block", {
	description = "Bituminous Coal Block",
	tiles = {"coke_bituminous_coal_block.png"},
	drop = "minerals:bituminous_coal 9",
	particle_image = {"coke_bituminous_coal_block.png"},
	groups = {crumbly=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("coke:lignite_block", {
	description = "Lignite Block",
	tiles = {"coke_lignite_block.png"},
	drop = "minerals:lignite 9",
	particle_image = {"coke_coal_block.png"},
	groups = {crumbly=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("coke:coke_block", {
	description = "Coke Block",
	tiles = {"coke_coke_block.png"},
	drop = "coke:coke 8",
	particle_image = {"coke_coke_block.png"},
	groups = {crumbly=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("coke:coke", {
	description = "Coke",
	inventory_image = "coke_coke.png",
})

minetest.register_craft({
	type = "fuel",
	recipe = "coke:coke",
	burntime = 45,
})

minetest.register_craft({
	output = "coke:bituminous_coal_block",
	recipe = {{"minerals:bituminous_coal","minerals:bituminous_coal","minerals:bituminous_coal"},
			{"minerals:bituminous_coal","minerals:bituminous_coal","minerals:bituminous_coal"},
			{"minerals:bituminous_coal","minerals:bituminous_coal","minerals:bituminous_coal"}},
})

minetest.register_craft({
	output = "coke:lignite_block",
	recipe = {{"minerals:lignite","minerals:lignite","minerals:lignite"},
			{"minerals:lignite","minerals:lignite","minerals:lignite"},
			{"minerals:lignite","minerals:lignite","minerals:lignite"}},
})

function coke.register_coke_furnace(metal)
	minetest.register_craft({
		output = "coke:"..metal.."_furnace",
		recipe = {{"metals:"..metal.."_ingot","","metals:"..metal.."_ingot"},
				{"metals:"..metal.."_sheet","default:coal_lump","metals:"..metal.."_sheet"},
				{"","metals:"..metal.."_doubleingot",""}},
	})

	coke.furnace_formspec = 
		"size[8,7]"..
		"image[2,1;1,1;default_furnace_fire_bg.png]"..
		"list[current_name;fuel;3.5,1;1,1;]"..
		"list[current_player;main;0,3;8,4;]"

	minetest.register_node("coke:"..metal.."_furnace", {
		description = "Coke Furnace",
		tiles = {"coke_furnace_"..metal.."_top.png","coke_furnace_"..metal..".png","coke_furnace_"..metal..".png",
			"coke_furnace_"..metal..".png","coke_furnace_"..metal..".png","coke_furnace_"..metal.."_front.png"},
		particle_image = {"coke_furnace_"..metal.."_front.png"},
		groups = {oddly_breakable_by_hand=1},
		paramtype2 = "facedir",
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", coke.furnace_formspec)
			meta:set_string("infotext", "Coke Furnace")
			meta:set_int("active", 0)
			local inv = meta:get_inventory()
			inv:set_size("fuel", 1)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then return false end
			return true
		end,
	})

	minetest.register_node("coke:"..metal.."_furnace_active", {
		description = "Coke Furnace",
		tiles = {"coke_furnace_"..metal.."_top_active.png","coke_furnace_"..metal..".png","coke_furnace_"..metal..".png",
			"coke_furnace_"..metal..".png","coke_furnace_"..metal..".png","coke_furnace_"..metal.."_front_active.png"},
		particle_image = {"coke_furnace_"..metal.."_front.png"},
		light_source = 12,
		drop = "coke:"..metal.."_furnace",
		groups = {igniter=1, not_in_creative_inventory=1},
		paramtype2 = "facedir",
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", coke.furnace_formspec)
			meta:set_string("infotext", "Coke Furnace")
			meta:set_int("active", 0)
			local inv = meta:get_inventory()
			inv:set_size("fuel", 1)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then
				return false
			end
			return true
		end,
	})

	minetest.register_abm({
		nodenames = {"coke:"..metal.."_furnace","coke:"..metal.."_furnace_active"},
		interval = 1.0,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			
			for i, name in ipairs({"fuel_totaltime", "fuel_time"}) do
				if meta:get_string(name) == "" then
					meta:set_float(name, 0.0)
				end
			end
			
			if meta:get_int("active") == 1 then
				if meta:get_int("sound_play") ~= 1 then
					meta:set_int("sound_handle", minetest.sound_play("furnace_burning", {pos=pos, max_hear_distance = 8,loop=true}))
					meta:set_int("sound_play", 1)
				end
			
				local was_active = false
				local bird = [[
				  ___
				 (0,0)
				 (\   /)
				  ^^
				  ]]
				if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
					was_active = true
					meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
					local b = true
					local side = minetest.env:get_node(pos).param2
					local xmin, xmax, zmin, zmax, ymax = 0, 0, 0, 0, 10
					if side==0 then
						xmin =0
						xmax = 0
						zmin =1
						zmax = 3
						local bb = true
						for j=0,10 do
							if bb then
								local block = minetest.env:get_node({x=pos.x,y=pos.y+j,z=pos.z+1})
								if block.name ~= "air" and block.name ~= "coke:lignite_block" and
									block.name ~= "coke:bituminous_coal_block" and block.name ~= "coke:coke_block" then
									ymax=j
									bb=false
								end
							end
						end
					end
					if side==1 then
						xmin =1
						xmax = 3
						zmin =0
						zmax = 0
						local bb = true
						for j=0,10 do
							if bb then
								local block = minetest.env:get_node({x=pos.x+1,y=pos.y+j,z=pos.z})
								if block.name ~= "air" and block.name ~= "coke:lignite_block" and
									block.name ~= "coke:bituminous_coal_block" and block.name ~= "coke:coke_block" then
									ymax=j
									bb=false
								end
							end
						end
					end
					if side==2 then
						xmin =0
						xmax = 0
						zmin =-3
						zmax = -1
						local bb = true
						for j=0,10 do
							if bb then
								local block = minetest.env:get_node({x=pos.x,y=pos.y+j,z=pos.z-1})
								if block.name ~= "air" and block.name ~= "coke:lignite_block" and
									block.name ~= "coke:bituminous_coal_block" and block.name ~= "coke:coke_block" then
									ymax=j
									bb=false
								end
							end
						end
					end
					if side==3 then
						xmin =-3
						xmax = -1
						zmin =0
						zmax = 0
						local bb = true
						for j=0,10 do
							if bb then
								local block = minetest.env:get_node({x=pos.x-1,y=pos.y+j,z=pos.z})
								if block.name ~= "air" and block.name ~= "coke:lignite_block" and
									block.name ~= "coke:bituminous_coal_block" and block.name ~= "coke:coke_block" then
									ymax=j
									bb=false
								end
							end
						end
					end
					for x=xmin, xmax do
					for y=0,ymax-1 do
					for z=zmin, zmax do
						if b and math.random(128) == 1 then
							local p ={x=pos.x+x, y=pos.y+y, z=pos.z+z}
							if minetest.env:get_node(p).name == "coke:bituminous_coal_block" or 
								minetest.env:get_node(p).name == "coke:lignite_block" then
								minetest.env:set_node(p,{name="coke:coke_block"})
								b = false
							end
						end
					end
					end
					end
				end
			
				if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
					local percent = math.floor(meta:get_float("fuel_time") /
							meta:get_float("fuel_totaltime") * 100)
					meta:set_string("infotext","Furnace active: "..percent.."%")
					hacky_swap_node(pos,"coke:"..metal.."_furnace_active")
					meta:set_string("formspec",
						"size[8,7]"..
						"image[2,1;1,1;default_furnace_fire_bg.png^[lowpart:"..
							(100-percent)..":default_furnace_fire_fg.png]"..
						"list[current_name;fuel;3.5,1;1,1;]"..
						"list[current_player;main;0,3;8,4;]")
					return
				end

				local fuel = nil
				local cookeds = {}
				local fuellist = inv:get_list("fuel")
				if fuellist then
					fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
				end
		
				if fuel.time <= 0 then
					meta:set_string("infotext","Furnace out of fuel")
					hacky_swap_node(pos,"coke:"..metal.."_furnace")
					meta:set_string("formspec", coke.furnace_formspec)
					meta:set_int("active", 0)
					meta:set_int("sound_play", 0)
					minetest.sound_stop(meta:get_int("sound_handle"))
					return
				end

				meta:set_string("fuel_totaltime", fuel.time)
				meta:set_string("fuel_time", 0)
			
				local stack = inv:get_stack("fuel", 1)
				stack:take_item()
				inv:set_stack("fuel", 1, stack)
			end
		end,
	})
end

coke.register_coke_furnace("bronze")