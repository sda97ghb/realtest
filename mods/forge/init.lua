forge = {}

function forge.register(metal)
	minetest.register_craft({
		output = "forge:"..metal,
		recipe = {{"","metals:"..metal.."_sheet",""},
				{"metals:"..metal.."_ingot","coke:coke","metals:"..metal.."_ingot"},
				{"","metals:"..metal.."_doubleingot",""}},
	})

	forge.formspec = 
		"size[8,7]"..
		"image[1,1;1,1;default_furnace_fire_bg.png]"..
		"list[current_name;fuel;2.5,1;1,1;]"..
		"list[current_name;out;4.5,1;1,1;]"..
		"list[current_player;main;0,3;8,4;]"

	minetest.register_node("forge:"..metal, {
		description = "Forge",
		tiles = {"forge_"..metal..".png","forge_"..metal..".png","forge_"..metal..".png",
			"forge_"..metal..".png","forge_"..metal.."_back.png","forge_"..metal.."_front.png"},
		particle_image = {"forge_"..metal..".png"},
		groups = {oddly_breakable_by_hand=1},
		paramtype2 = "facedir",
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", forge.formspec)
			meta:set_string("infotext", "Forge")
			meta:set_int("active", 0)
			local inv = meta:get_inventory()
			inv:set_size("fuel", 1)
			inv:set_size("out", 1)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then return false end
			if not inv:is_empty("out") then return false end
			return true
		end,
	})

	minetest.register_node("forge:"..metal.."_active", {
		description = "Forge",
		tiles = {"forge_"..metal..".png","forge_"..metal..".png","forge_"..metal..".png",
			"forge_"..metal..".png","forge_"..metal.."_back.png","forge_"..metal.."_front_active.png"},
		particle_image = {"forge_"..metal..".png"},
		light_source = 12,
		drop = "forge:"..metal,
		groups = {igniter=1, not_in_creative_inventory=1},
		paramtype2 = "facedir",
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", forge.formspec)
			meta:set_string("infotext", "Forge")
			meta:set_int("active", 0)
			local inv = meta:get_inventory()
			inv:set_size("fuel", 1)
			inv:set_size("out", 1)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then return false end
			if not inv:is_empty("out") then return false end
			return true
		end,
	})

	minetest.register_abm({
		nodenames = {"forge:"..metal, "forge:"..metal.."_active"},
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

				if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
					was_active = true
					meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
					local b, bb = true, true
					local side = minetest.env:get_node(pos).param2
					local xd, zd, ymax = 0, 0, 6
					if side==0 then
						xd = 0
						zd = 1
					end
					if side==1 then
						xd = 1
						zd = 0
					end
					if side==2 then
						xd = 0
						zd = -1
					end
					if side==3 then
						xd = -1
						zd = 0
					end
					for y=0,ymax-1 do
						if b --[[and math.random(128) == 1]] then
							local p ={x=pos.x+xd, y=pos.y+y, z=pos.z+zd}
							if minetest.env:get_node(p).name == "default:dirt" then
								minetest.env:set_node(p,{name="default:stone"})
								b = false
							end
						end
					end
				end
			
				if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
					local percent = math.floor(meta:get_float("fuel_time") /
							meta:get_float("fuel_totaltime") * 100)
					meta:set_string("infotext","Forge active: "..percent.."%")
					hacky_swap_node(pos,"forge:"..metal.."_active")
					meta:set_string("formspec",
						"size[8,7]"..
						"image[1,1;1,1;default_furnace_fire_bg.png^[lowpart:"..
							(100-percent)..":default_furnace_fire_fg.png]"..
						"list[current_name;fuel;2.5,1;1,1;]"..
						"list[current_name;fuel;4.5,1;1,1;]"..
						"list[current_player;main;0,3;8,4;]")
					return
				end

				local fuel = nil
				local cookeds = {}
				local fuellist = inv:get_list("fuel")
				if fuellist then
					fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
				end
				local fuelstack = inv:get_stack("fuel", 1)
				if fuelstack:get_name() ~= "coke:coke" then fuel.time = 0 end
				if fuel.time <= 0 then
					meta:set_string("infotext","Forge out of fuel")
					hacky_swap_node(pos,"forge:"..metal)
					meta:set_string("formspec", forge.formspec)
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

forge.register("bronze")