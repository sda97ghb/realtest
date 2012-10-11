sawing_table = {}

local table_containts = function(t, v)
	for _, i in ipairs(t) do
		if i==v then
			return true
		end
	end
	return false
end

minetest.register_node("sawing_table:self", {
	description = "Sawing table",
	tiles = {"sawing_table_top.png","sawing_table_top.png","sawing_table_side2.png","sawing_table_side2.png","sawing_table_side.png","sawing_table_side.png",},
	groups = {oddly_breakable_by_hand=2, cracky=3, dig_immediate=1},
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,-0.2,0.5,0.5},
			{0.2,-0.5,-0.5,0.5,0.5,0.5},
			{-0.4,-0.43,-0.43,0.4,-0.2,0.43},
			{-0.4,0.2,-0.43,0.4,0.43,0.43},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,-0.2,0.5,0.5},
			{0.2,-0.5,-0.5,0.5,0.5,0.5},
			{-0.4,-0.43,-0.43,0.4,-0.2,0.43},
			{-0.4,0.2,-0.43,0.4,0.43,0.43},
		},
	},
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("ingot") then
			return false
		elseif not inv:is_empty("res") then
			return false
		elseif not inv:is_empty("recipe") then
			return false
		end
		return true
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", "invsize[8,10;]"..
				"list[current_name;input;1,1.5;1,1;]"..
				"list[current_name;recipe;6,1.5;1,1;]"..
				"list[current_name;res;3,1.5;1,1;]"..
				"label[1,1;Input:]"..
				"label[6,1;Recipe:]"..
				"label[3,1;Output:]"..
				"button[4,2.5;2,3;saw;Saw]"..
				"list[current_player;main;0,6;8,4;]")
		meta:set_string("infotext", "Sawing table")
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("recipe", 1)
		inv:set_size("res", 1)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		if fields["saw"] then
			local inputstack = inv:get_stack("input", 1)
			local recipestack = inv:get_stack("recipe", 1)
			local resstack = inv:get_stack("res", 1)
			
			if inputstack:get_name()=="default:tree" then
				inv:add_item("res","default:wood 4")
				inputstack:take_item()
				inv:set_stack("input",1,inputstack)
				return
			end
		end
	end,
})