furnace = {}

function furnace.check_furnace_blocks(pos)
	local furnace_blocks = {{x=1,y=0,z=-1}, {x=1,y=0,z=0}, {x=1,y=0,z=1}, {x=0,y=0,z=-1}, {x=0,y=0,z=1}, {x=-1,y=0,z=-1}, {x=-1,y=0,z=0}, {x=-1,y=0,z=1}, {x=0,y=-1,z=0}, {x=1,y=-1,z=-1}, {x=1,y=-1,z=0}, {x=1,y=-1,z=1}, {x=0,y=-1,z=-1}, {x=0,y=-1,z=1}, {x=-1,y=-1,z=-1}, {x=-1,y=-1,z=0}, {x=-1,y=-1,z=1}}
	for n = 1,#furnace_blocks do
		local v = furnace_blocks[n]
			if minetest.env:get_node({x=pos.x+v.x,y=pos.y+v.y,z=pos.z+v.z}).name ~= "default:cobble" then
				return false
			end
		end
	return true
end

--[[furnace.formspec =
	"invsize[8,9;]"..
	"image[2,3;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2,2;1,1;]"..
	"list[current_name;src;1,1;1,1;]"..
	"list[current_name;dst;2,1;2,1;]"..
	"list[current_name;add;5,1;2,2;]"..
	"label[0,1;Source:]"..
	"label[0,2;Fuel:]"..
	"label[2,0;Output:]"..
	"label[5,0;Additional:]"..
	"list[current_player;main;0,5;8,4;]"]]
furnace.formspec = 
	"invsize[8,10;]"..
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
		local inv = meta:get_inventory()
		inv:set_size("src1", 1)
		inv:set_size("dst1", 1)
		inv:set_size("src2", 1)
		inv:set_size("dst2", 1)
		inv:set_size("src3", 1)
		inv:set_size("dst3", 1)
		inv:set_size("src4", 1)
		inv:set_size("dst4", 1)
		inv:set_size("src5", 1)
		inv:set_size("dst5", 1)
		inv:set_size("fuel", 1)
	end,
	--[[can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("src") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("add") then
			return false
		end
		return true
	end,]]
})

minetest.register_node("furnace:self_active", {
	description = "Furnace",
	tiles = {"furnace_top_active.png", "furnace_bottom.png", "furnace_side_active.png"},
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
	groups = {crumbly=3, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", furnace.formspec)
		meta:set_string("infotext", "Furnace")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 2)
		inv:set_size("add", 4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("src") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("add") then
			return false
		end
		return true
	end,
})

function hacky_swap_node(pos,name)
	local node = minetest.env:get_node(pos)
	local meta = minetest.env:get_meta(pos)
	local meta0 = meta:to_table()
	if node.name == name then
		return
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.env:set_node(pos,node)
	meta = minetest.env:get_meta(pos)
	meta:from_table(meta0)
end

--[[minetest.register_abm({
	nodenames = {"furnace:self","furnace:self_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		for i, name in ipairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end
		
		local inv = meta:get_inventory()
		
		if not furnace.check_furnace_blocks(pos) then
			for _, v in ipairs({
				{"fuel", 1,},
				{"src", 1,},
				{"dst", 2,},
				{"add", 4,},
			}) do
				local name, size = v[1], v[2]
				for n = 1,size do
					if not inv:is_empty(name) then
						minetest.env:add_item(pos, inv:get_stack(name, n):get_name() .. " " .. inv:get_stack(name, n):get_count())
					end
				end
			end
			minetest.env:remove_node(pos)
			return
		end

		local srclist = inv:get_list("src")
		local cooked = nil
		
		if srclist then
			cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		
		local was_active = false
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",cooked.item) then
					-- Put result in "dst" list
					inv:add_item("dst", cooked.item)
					-- take stuff from "src" list
					srcstack = inv:get_stack("src", 1)
					srcstack:take_item()
					inv:set_stack("src", 1, srcstack)
				--else
					--print("Could not insert '"..cooked.item.."'")
				end
				meta:set_string("src_time", 0)
			end
		end
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext","Furnace active: "..percent.."%")
			hacky_swap_node(pos,"furnace:self_active")
			meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[2,3;1,1;default_furnace_fire_bg.png^[lowpart:"..
						(100-percent)..":default_furnace_fire_fg.png]"..
				"list[current_name;fuel;2,2;1,1;]"..
				"list[current_name;src;1,1;1,1;]"..
				"list[current_name;dst;2,1;2,1;]"..
				"list[current_name;add;5,1;2,2;]"..
				"label[0,1;Source:]"..
				"label[0,2;Fuel:]"..
				"label[2,0;Output:]"..
				"label[5,0;Additional:]"..
				"list[current_player;main;0,5;8,4;]")
			return
		end

		local fuel = nil
		local cooked = nil
		local fuellist = inv:get_list("fuel")
		local srclist = inv:get_list("src")
		
		if srclist then
			cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		if fuellist then
			fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
			meta:set_string("infotext","Furnace out of fuel")
			hacky_swap_node(pos,"furnace:self")
			meta:set_string("formspec", furnace.formspec)
			return
		end

		if cooked.item:is_empty() then
			if was_active then
				meta:set_string("infotext","Furnace is empty")
				hacky_swap_node(pos,"furnace:self")
				meta:set_string("formspec", furnace.formspec)
			end
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)
		
		local stack = inv:get_stack("fuel", 1)
		stack:take_item()
		inv:set_stack("fuel", 1, stack)
	end,
})]]
