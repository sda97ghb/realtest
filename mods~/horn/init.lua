horn = {}
horn.recipes = {}

function realtest.register_horn_recipe(mineral,count_mineral,metal,count_metal)
	local horn_recipe={mineral=mineral, count_mineral=count_mineral, metal=metal, count_metal=count_metal}
	table.insert(horn.recipes,horn_recipe)
	
end

function horn.register(metal)
	minetest.register_craft({
		output = "horn:"..metal,
		recipe = {{"","metals:"..metal.."_sheet",""},
				{"metals:"..metal.."_ingot","coke:coke","metals:"..metal.."_ingot"},
				{"","metals:"..metal.."_doubleingot",""}},
	})

	horn.formspec = 
		"size[8,7]"..
		"image[1,1;1,1;default_furnace_fire_bg.png]"..
		"list[current_name;fuel;2.5,1;1,1;]"..
		"list[current_name;out;4.5,1;1,1;]"..
		"list[current_name;molds;6.5,1;1,1;]"..
		"list[current_player;main;0,3;8,4;]"

	minetest.register_node("horn:"..metal, {
		description = "Horn",
		tiles = {"horn_"..metal..".png","horn_"..metal..".png","horn_"..metal..".png",
			"horn_"..metal..".png","horn_"..metal.."_back.png","horn_"..metal.."_front.png"},
		particle_image = {"horn_"..metal..".png"},
		groups = {oddly_breakable_by_hand=1},
		paramtype2 = "facedir",
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", horn.formspec)
			meta:set_string("infotext", "Horn")
			meta:set_int("active", 0)
			local inv = meta:get_inventory()
			inv:set_size("fuel", 1)
			inv:set_size("out", 1)
			inv:set_size("molds", 1)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then return false end
			if not inv:is_empty("out") then return false end
			if not inv:is_empty("molds") then return false end
			return true
		end,
	})

	minetest.register_node("horn:"..metal.."_active", {
		description = "Horn",
		tiles = {"horn_"..metal..".png","horn_"..metal..".png","horn_"..metal..".png",
			"horn_"..metal..".png","horn_"..metal.."_back.png","horn_"..metal.."_front_active.png"},
		particle_image = {"horn_"..metal..".png"},
		light_source = 12,
		drop = "horn:"..metal,
		groups = {igniter=1, not_in_creative_inventory=1},
		paramtype2 = "facedir",
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", horn.formspec)
			meta:set_string("infotext", "Horn")
			meta:set_int("active", 0)
			local inv = meta:get_inventory()
			inv:set_size("fuel", 1)
			inv:set_size("out", 1)
			inv:set_size("molds", 1)
		end,
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then return false end
			if not inv:is_empty("out") then return false end
			if not inv:is_empty("molds") then return false end
			return true
		end,
	})

	minetest.register_abm({
		nodenames = {"horn:"..metal, "horn:"..metal.."_active"},
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
					local b = true
					local ymax = 16
					local side = minetest.env:get_node(pos).param2
					side = side - math.floor(side/4)*4
					local xd = (side-math.floor(side/2)*2)*(2-side);
					side = side + 1
					local zd = (side-math.floor(side/2)*2)*(2-side);
					for y=0,ymax-1 do
						local p ={x=pos.x+xd, y=pos.y+y, z=pos.z+zd}
						for m = 1, #mineralsi.list do
							if mineralsi.list[m].ore then
								if minetest.env:get_node(p).name == "minerals:"..mineralsi.list[m].name.."_block" then
									if b and math.random(64) == 1 then
										minetest.env:set_node(p,{name = "minerals:"..mineralsi.list[m].name.."_block_liquid"})
									end
									b=false
								end
							end
						end
					end
					
					local out_stack = inv:get_stack("out", 1)
					local molds_stack = inv:get_stack("molds", 1)
					local out_item = ""
					for m = 1, #mineralsi.list do
						if mineralsi.list[m].ore and
							minetest.env:get_node({x=pos.x+xd, y=pos.y, z=pos.z+zd}).name == "minerals:"..mineralsi.list[m].name.."_block_liquid" then
							out_item = "metals:"..mineralsi.list[m].metal.."_unshaped"
						end
					end
					
					if molds_stack:get_count() > 3 and out_item~= "" then
						if inv:room_for_item("out", out_item) then
							inv:add_item("out", out_item)
							inv:add_item("out", out_item)
							inv:add_item("out", out_item)
							inv:add_item("out", out_item)
							molds_stack:take_item()
							molds_stack:take_item()
							molds_stack:take_item()
							molds_stack:take_item()
							inv:set_stack("molds", 1, molds_stack)
							minetest.env:remove_node({x=pos.x+xd, y=pos.y, z=pos.z+zd})
							nodeupdate({x=pos.x+xd, y=pos.y, z=pos.z+zd})
						end
					end
				end
			
				if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
					local percent = math.floor(meta:get_float("fuel_time") /
							meta:get_float("fuel_totaltime") * 100)
					meta:set_string("infotext","Horn active: "..percent.."%")
					hacky_swap_node(pos,"horn:"..metal.."_active")
					meta:set_string("formspec",
						"size[8,7]"..
						"image[1,1;1,1;default_furnace_fire_bg.png^[lowpart:"..
							(100-percent)..":default_furnace_fire_fg.png]"..
						"list[current_name;fuel;2.5,1;1,1;]"..
						"list[current_name;out;4.5,1;1,1;]"..
						"list[current_name;molds;6.5,1;1,1;]"..
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
				if fuelstack:get_name() ~= "coke:coke" and fuelstack:get_name() ~= "minerals:anthracite" then fuel.time = 0 end
				if fuel.time <= 0 then
					meta:set_string("infotext","Horn out of fuel")
					hacky_swap_node(pos,"horn:"..metal)
					meta:set_string("formspec", horn.formspec)
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

horn.register("bronze")