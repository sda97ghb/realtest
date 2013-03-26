coke_furnace = {}

function coke_furnace.check_furnace_blocks(pos)
	local coke_furnace_blocks = {
		{x=-1,y=-1,z=0},
		{x=0,y=-1,z=0},
		{x=1,y=-1,z=0},
		{x=-1,y=-1,z=1},
		{x=0,y=-1,z=1},
		{x=1,y=-1,z=1},
		{x=-1,y=-1,z=2},
		{x=0,y=-1,z=2},
		{x=1,y=-1,z=2},
		{x=-1,y=-1,z=3},
		{x=0,y=-1,z=3},
		{x=1,y=-1,z=3},
		{x=-1,y=-1,z=4},
		{x=0,y=-1,z=4},
		{x=1,y=-1,z=4},
		
		{x=-1,y=0,z=0},
		{x=1,y=0,z=0},
		{x=-1,y=0,z=1},
		{x=1,y=0,z=1},
		{x=-1,y=0,z=2},
		{x=1,y=0,z=2},
		{x=-1,y=0,z=3},
		{x=1,y=0,z=3},
		{x=-1,y=0,z=4},
		{x=0,y=0,z=4},
		{x=1,y=0,z=4},
		
		{x=-1,y=1,z=0},
		{x=1,y=1,z=0},
		{x=-1,y=1,z=1},
		{x=1,y=1,z=1},
		{x=-1,y=1,z=2},
		{x=1,y=1,z=2},
		{x=-1,y=1,z=3},
		{x=1,y=1,z=3},
		{x=-1,y=1,z=4},
		{x=0,y=1,z=4},
		{x=1,y=1,z=4},
		
		{x=-1,y=2,z=0},
		{x=1,y=2,z=0},
		{x=-1,y=2,z=1},
		{x=1,y=2,z=1},
		{x=-1,y=2,z=2},
		{x=1,y=2,z=2},
		{x=-1,y=2,z=3},
		{x=1,y=2,z=3},
		{x=-1,y=2,z=4},
		{x=0,y=2,z=4},
		{x=1,y=2,z=4},
		
		{x=-1,y=3,z=0},
		{x=0,y=3,z=0},
		{x=1,y=3,z=0},
		{x=-1,y=3,z=1},
		{x=1,y=3,z=1},
		{x=-1,y=3,z=2},
		{x=1,y=3,z=2},
		{x=-1,y=3,z=3},
		{x=1,y=3,z=3},
		{x=-1,y=3,z=4},
		{x=0,y=3,z=4},
		{x=1,y=3,z=4},
		
		{x=-1,y=4,z=0},
		{x=0,y=4,z=0},
		{x=1,y=4,z=0},
		{x=-1,y=4,z=1},
		{x=0,y=4,z=1},
		{x=1,y=4,z=1},
		{x=-1,y=4,z=2},
		{x=0,y=4,z=2},
		{x=1,y=4,z=2},
		{x=-1,y=4,z=3},
		{x=0,y=4,z=3},
		{x=1,y=4,z=3},
		{x=-1,y=4,z=4},
		{x=0,y=4,z=4},
		{x=1,y=4,z=4},
		}
	for n = 1,#coke_furnace_blocks do
		local v = coke_furnace_blocks[n]
			if 		  minetest.env:get_node({x=pos.x+v.x,y=pos.y+v.y,z=pos.z+v.z}).name ~= "default:brick" --[[and
				minetest.env:get_node_or_nil({x=pos.x+v.x,y=pos.y+v.y,z=pos.z+v.z})]] then
				return false
			end
		end
	return true
end

minetest.register_node("coke:bituminous_coal_block", {
	description = "Coal Block",
	tiles = {"coke_coal_block.png"},
	drop = "minerals:bituminous_coal 9",
	particle_image = {"coke_coal_block.png"},
	groups = {crumbly=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("coke:lignite_block", {
	description = "Coal Block",
	tiles = {"coke_coal_block.png"},
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

minetest.register_craft({
	output = "coke:furnace",
	recipe = {{"metals:bronze_ingot","","metals:bronze_ingot"},
			{"metals:bronze_sheet","default:coal_lump","metals:bronze_sheet"},
			{"","metals:bronze_doubleingot",""}},
})

coke_furnace.formspec = 
	"size[8,7]"..
 	"image[2,1;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;3.5,1;1,1;]"..
	"list[current_player;main;0,3;8,4;]"

minetest.register_node("coke:furnace", {
	description = "Coke Furnace",
	tiles = {"coke_furnace_top.png","coke_furnace.png","coke_furnace.png","coke_furnace.png","coke_furnace.png","coke_furnace_front.png"},
	particle_image = {"coke_furnace_front.png"},
	groups = {crumbly=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", coke_furnace.formspec)
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

minetest.register_node("coke:furnace_active", {
	description = "Coke Furnace",
	tiles = {"coke_furnace_top_active.png","coke_furnace.png","coke_furnace.png","coke_furnace.png","coke_furnace.png","coke_furnace_front_active.png"},
	particle_image = {"coke_furnace_front.png"},
	light_source = 12,
	drop = "coke:furnace",
	groups = {igniter=1,crumbly=3, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", coke_furnace.formspec)
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
	nodenames = {"coke:furnace","coke:furnace_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		if not coke_furnace.check_furnace_blocks(pos) then
			if not inv:is_empty("fuel") then
				local isn=inv:get_stack("fuel", 1)
				minetest.env:add_item(pos,
					{name=isn:get_name(),
					 count=isn:get_count(),
					 wear=isn:get_wear(),
					 metadata=isn:get_metadata()})
			end
			minetest.env:remove_node(pos)
			return
		end
		
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
				local b=true
				for y=0,3 do
					for z=1,3 do
						if b and math.random(128) == 1 then
							local p ={x=pos.x, y=pos.y+y, z=pos.z+z}
							if minetest.env:get_node(p).name == "coke:bituminous_coal_block" or 
								minetest.env:get_node(p).name == "coke:lignite_block" then
								minetest.env:set_node(p,{name="coke:coke_block"})
								b = false
							end
						end
					end
				end
			end
		
			if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
				local percent = math.floor(meta:get_float("fuel_time") /
						meta:get_float("fuel_totaltime") * 100)
				meta:set_string("infotext","Furnace active: "..percent.."%")
				hacky_swap_node(pos,"coke:furnace_active")
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
				hacky_swap_node(pos,"coke:furnace")
				meta:set_string("formspec", coke_furnace.formspec)
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