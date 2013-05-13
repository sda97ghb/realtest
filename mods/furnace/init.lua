furnace = {}

function furnace.check_furnace_blocks(pos)
	local furnace_blocks = {{x=1,y=0,z=-1}, {x=1,y=0,z=0}, {x=1,y=0,z=1}, {x=0,y=0,z=-1}, {x=0,y=0,z=1}, {x=-1,y=0,z=-1}, {x=-1,y=0,z=0}, {x=-1,y=0,z=1}, {x=0,y=-1,z=0}, {x=1,y=-1,z=-1}, {x=1,y=-1,z=0}, {x=1,y=-1,z=1}, {x=0,y=-1,z=-1}, {x=0,y=-1,z=1}, {x=-1,y=-1,z=-1}, {x=-1,y=-1,z=0}, {x=-1,y=-1,z=1}}
	for n = 1,#furnace_blocks do
		local v = furnace_blocks[n]
			if minetest.env:get_node_or_nil({x=pos.x+v.x,y=pos.y+v.y,z=pos.z+v.z}) and 
					minetest.get_node_group(minetest.env:get_node({x=pos.x+v.x,y=pos.y+v.y,z=pos.z+v.z}).name, "stone") ~= 1 then
				return false
			end
		end
	return true
end

furnace.formspec = 
	"size[8,10]"..
	"list[current_name;src1;1.5,0;1,1;]"..
	"list[current_name;dst1;1.5,1;1,1;]"..
	"list[current_name;src2;2.5,1;1,1;]"..
	"list[current_name;dst2;2.5,2;1,1;]"..
	"list[current_name;src3;3.5,2;1,1;]"..
	"list[current_name;dst3;3.5,3;1,1;]"..
	"list[current_name;src4;4.5,1;1,1;]"..
	"list[current_name;dst4;4.5,2;1,1;]"..
	"list[current_name;src5;5.5,0;1,1;]"..
	"list[current_name;dst5;5.5,1;1,1;]"..
	"image[3.5,4;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;3.5,5;1,1;]"..
	"list[current_player;main;0,6;8,4;]"
	
minetest.register_node("furnace:self", {
	description = "Furnace",
	tiles = {"furnace_top.png", "furnace_bottom.png", "furnace_side.png"},
	particle_image = {"furnace_top.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.2,0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.2,0.5},
		},
	},
	drop = "",
	groups = {crumbly=3, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", furnace.formspec)
		meta:set_string("infotext", "Furnace")
		meta:set_int("active", 0)
		local inv = meta:get_inventory()
		for i = 1,5 do
			inv:set_size("src"..i, 1)
			inv:set_size("dst"..i, 1)
		end
		inv:set_size("fuel", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		for i = 1,5 do
			if not inv:is_empty("src"..i) or not inv:is_empty("dst"..i) then
				return false
			end
		end
		if not inv:is_empty("fuel") then
			return false
		end
		return true
	end,
})

minetest.register_node("furnace:self_active", {
	description = "Furnace",
	tiles = {"furnace_top_active.png", "furnace_bottom.png", "furnace_side_active.png"},
	particle_image = {"furnace_top_active.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.2,0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.2,0.5},
		},
	},
	light_source = 12,
	drop = "",
	groups = {igniter=1,crumbly=3, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", furnace.formspec)
		meta:set_string("infotext", "Furnace")
		meta:set_int("active", 0)
		local inv = meta:get_inventory()
		for i = 1,5 do
			inv:set_size("src"..i, 1)
			inv:set_size("dst"..i, 1)
		end
		inv:set_size("fuel", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		for i = 1,5 do
			if not inv:is_empty("src"..i) or not inv:is_empty("dst"..i) then
				return false
			end
		end
		if not inv:is_empty("fuel") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"furnace:self","furnace:self_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		if not furnace.check_furnace_blocks(pos) then
			for _, v in ipairs({
				{"fuel", 1,},
				{"src1", 1,}, {"dst1", 1,},
				{"src2", 1,}, {"dst2", 1,},
				{"src3", 1,}, {"dst3", 1,},
				{"src4", 1,}, {"dst4", 1,},
				{"src5", 1,}, {"dst5", 1,},
			}) do
				local name, size = v[1], v[2]
				for n = 1,size do
					if not inv:is_empty(name) then
						minetest.env:add_item(pos, 
							{name=inv:get_stack(name, 1):get_name(),
							 count=inv:get_stack(name, 1):get_count(),
							 wear=inv:get_stack(name, 1):get_wear(),
							 metadata=inv:get_stack(name, n):get_metadata()})
					end
				end
			end
			minetest.env:remove_node(pos)
			return
		end
		
		for i, name in ipairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime1",
				"src_time1",
				"src_totaltime2",
				"src_time2",
				"src_totaltime3",
				"src_time3",
				"src_totaltime4",
				"src_time4",
				"src_totaltime5",
				"src_time5",
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end
		
		if meta:get_int("active") == 1 then
			if meta:get_int("sound_play") ~= 1 then
				meta:set_int("sound_handle", minetest.sound_play("furnace_burning", {pos=pos, max_hear_distance = 8,loop=true}))
				meta:set_int("sound_play", 1)
			end
			local srclists = {}
			local cookeds = {}
			for i = 1,5 do
				srclists[i] = inv:get_list("src"..i)
				if srclists[i] then
					cookeds[i] = minetest.get_craft_result({method = "cooking", width = 1, items = srclists[i]})
				end
			end
		
			local was_active = false
			
			if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
				was_active = true
				meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
				for i = 1,5 do
					meta:set_float("src_time"..i, meta:get_float("src_time"..i) + 1)	
					
					if cookeds[i] and cookeds[i].item and meta:get_float("src_time"..i) >= cookeds[i].time then
						-- check if there's room for output in "dst" list
						if inv:room_for_item("dst"..i,cookeds[i].item) then
							-- Put result in "dst" list
							inv:add_item("dst"..i, cookeds[i].item)
							-- take stuff from "src" list
							srcstack = inv:get_stack("src"..i, 1)
							srcstack:take_item()
							inv:set_stack("src"..i, 1, srcstack)
						--else
							--print("Could not insert '"..cooked.item.."'")
						end
						meta:set_string("src_time"..i, 0)
					end
				end
			end
		
			if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
				local percent = math.floor(meta:get_float("fuel_time") /
						meta:get_float("fuel_totaltime") * 100)
				meta:set_string("infotext","Furnace active: "..percent.."%")
				hacky_swap_node(pos,"furnace:self_active")
				meta:set_string("formspec",
					"size[8,10]"..
					"list[current_name;src1;1.5,0;1,1;]"..
					"list[current_name;dst1;1.5,1;1,1;]"..
					"list[current_name;src2;2.5,1;1,1;]"..
					"list[current_name;dst2;2.5,2;1,1;]"..
					"list[current_name;src3;3.5,2;1,1;]"..
					"list[current_name;dst3;3.5,3;1,1;]"..
					"list[current_name;src4;4.5,1;1,1;]"..
					"list[current_name;dst4;4.5,2;1,1;]"..
					"list[current_name;src5;5.5,0;1,1;]"..
					"list[current_name;dst5;5.5,1;1,1;]"..
					"image[3.5,4;1,1;default_furnace_fire_bg.png^[lowpart:"..
						(100-percent)..":default_furnace_fire_fg.png]"..
					"list[current_name;fuel;3.5,5;1,1;]"..
					"list[current_player;main;0,6;8,4;]")
				return
			end

			local fuel = nil
			local cookeds = {}
			local fuellist = inv:get_list("fuel")
			local srclists = {}
			for i = 1,5 do
				srclists[i] = inv:get_list("src"..i)
				if srclists[i] then
					cookeds[i] = minetest.get_craft_result({method = "cooking", width = 1, items = srclists[i]})
				end
			end
			if fuellist then
				fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
			end
	
			if fuel.time <= 0 then
				meta:set_string("infotext","Furnace out of fuel")
				hacky_swap_node(pos,"furnace:self")
				meta:set_string("formspec", furnace.formspec)
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
