scribing_table = {}

minetest.register_craft({
	output = 'scribing_table:self',
	recipe = {
		{'','default:stick',''},
		{'default:wood','default:glass','default:wood'},
		{'default:wood','default:wood','default:wood'},
	}
})

local recipes = {
	{"metals:recipe_axe", 
		{0,1,0,0,0,
		 1,1,1,1,0,
		 1,1,1,1,1,
		 1,1,1,1,0,
		 0,1,0,0,0,}
	},
	{"metals:recipe_hammer", 
	    {1,1,1,1,1,
		 1,1,1,1,1,
		 1,1,1,1,1,
		 0,0,1,0,0,
		 0,0,0,0,0,}
	},
	{"metals:recipe_pick", 
		{0,1,1,1,0,
		 1,0,0,0,1,
		 0,0,0,0,0,
		 0,0,0,0,0,
		 0,0,0,0,0,}
	},
	{"metals:recipe_shovel", 
		{0,1,1,1,0,
		 0,1,1,1,0,
		 0,1,1,1,0,
		 0,1,1,1,0,
		 0,0,1,0,0,}
	},
	{"metals:recipe_spear", 
		{1,1,0,0,0,
		 1,1,1,0,0,
		 0,1,0,0,0,
		 0,0,0,0,0,
		 0,0,0,0,0,}
	},
	{"metals:recipe_sword", 
		{0,0,0,1,1,
		 0,0,1,1,1,
		 0,1,1,1,0,
		 0,1,1,0,0,
		 1,0,0,0,0,}
	},
}

local function check_recipe(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local paperstack, res_craft = inv:get_stack("paper", 1)
	if paperstack:get_name() == "default:paper" then
		for i = 1,#recipes do
			local f = true
			for j = 1,25 do
				local dye = inv:get_stack("dye", j)
				if  (minetest.registered_items[dye:get_name()].groups["dye"] == 1   and recipes[i][2][j] == 0) or
					(minetest.registered_items[dye:get_name()].groups["dye"] == nil and recipes[i][2][j] == 1) then
					f = false
					break
				end
			end
			if f then
				res_craft = recipes[i][1]
				if inv:room_for_item("res", res_craft) then
					paperstack:take_item()
					inv:set_stack("paper", 1, paperstack)
					for i=1,25 do
						local dye = inv:get_stack("dye",i)
						dye:take_item()
						inv:set_stack("dye", i, dye)
					end
					inv:add_item("res", res_craft)
				end
				break
			end
		end
	end
end

minetest.register_node("scribing_table:self", {
	description = "Scribing table",
	tiles = {"scribing_table_top.png", "default_wood.png", "default_wood.png^scribing_table_side.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.3,0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.3,0.5},
		},
	},
	groups = {oddly_breakable_by_hand=3, dig_immediate=2},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local s_formspec="invsize[8,10;]"..
				"list[current_name;paper;6,1;1,1;]"..
				"list[current_name;dye;0,1;5,5;]"..
				"list[current_name;res;6,4;1,1;]"..
				"label[6,0;Paper:]"..
				"label[2,0;Dye:]"..
				"label[6,3;Output:]"..
				"list[current_player;main;0,6;8,4;]"
		meta:set_string("formspec", s_formspec)
		meta:set_string("infotext", "Scribing table")
		local inv = meta:get_inventory()
		inv:set_size("paper", 1)
		inv:set_size("dye", 25)
		inv:set_size("res", 1)
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index,to_list, to_index, count, player)
		check_recipe(pos)
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		check_recipe(pos)
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		check_recipe(pos)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("paper") and inv:is_empty("dye") and inv:is_empty("res") then
			return true
		end
		return false
	end,
})
