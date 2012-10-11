scribing_table = {}

minetest.register_craft({
	output = 'scribing_table:self',
	recipe = {
		{'','default:stick',''},
		{'default:wood','default:glass','default:wood'},
		{'default:wood','default:wood','default:wood'},
	}
})

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
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("paper") then
			return false
		elseif not inv:is_empty("dye") then
			return false
		elseif not inv:is_empty("res") then
			return false
		end
		return true
	end,
})

dye_table={
	axe={0,1,0,0,0,
	     1,1,1,1,0,
	     1,1,1,1,1,
	     1,1,1,1,0,
	     0,1,0,0,0,
	},
	hammer={1,1,1,1,1,
	        1,1,1,1,1,
	        1,1,1,1,1,
	        0,0,1,0,0,
	        0,0,0,0,0,
	},
	pick={0,1,1,1,0,
	      1,0,0,0,1,
	      0,0,0,0,0,
	      0,0,0,0,0,
	      0,0,0,0,0,
	},
	shovel={0,1,1,1,0,
	        0,1,1,1,0,
	        0,1,1,1,0,
	        0,1,1,1,0,
	        0,0,1,0,0,
	},
	spear={1,1,0,0,0,
	       1,1,1,0,0,
	       0,1,0,0,0,
	       0,0,0,0,0,
	       0,0,0,0,0,
	},
	sword={1,0,0,0,0,
	       0,0,0,0,0,
	       0,0,0,0,0,
	       0,0,0,0,0,
	       0,0,0,0,0,
	},
}

minetest.register_abm({
	nodenames = {"scribing_table:self"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()

		local paperstack = inv:get_stack("paper", 1)
		
		if paperstack:get_name()=="default:paper" then
			local res_craft=""
			local b=true
			for i=1,25 do
				local dye = inv:get_stack("dye",i)
				if dye:get_name()~="default:leaves" and dye_table.axe[i]==1 then
					b=false
				end
				if dye:get_name()=="default:leaves" and dye_table.axe[i]==0 then
					b=false
				end
			end
			if b==true then res_craft="metals:recipe_axe" end
			local b=true
			for i=1,25 do
				local dye = inv:get_stack("dye",i)
				if dye:get_name()~="default:leaves" and dye_table.hammer[i]==1 then
					b=false
				end
				if dye:get_name()=="default:leaves" and dye_table.hammer[i]==0 then
					b=false
				end
			end
			if b==true then res_craft="metals:recipe_hammer" end
			local b=true
			for i=1,25 do
				local dye = inv:get_stack("dye",i)
				if dye:get_name()~="default:leaves" and dye_table.pick[i]==1 then
					b=false
				end
				if dye:get_name()=="default:leaves" and dye_table.pick[i]==0 then
					b=false
				end
			end
			if b==true then res_craft="metals:recipe_pick" end
			local b=true
			for i=1,25 do
				local dye = inv:get_stack("dye",i)
				if dye:get_name()~="default:leaves" and dye_table.shovel[i]==1 then
					b=false
				end
				if dye:get_name()=="default:leaves" and dye_table.shovel[i]==0 then
					b=false
				end
			end
			if b==true then res_craft="metals:recipe_shovel" end
			local b=true
			for i=1,25 do
				local dye = inv:get_stack("dye",i)
				if dye:get_name()~="default:leaves" and dye_table.spear[i]==1 then
					b=false
				end
				if dye:get_name()=="default:leaves" and dye_table.spear[i]==0 then
					b=false
				end
			end
			if b==true then res_craft="metals:recipe_spear" end
			local b=true
			for i=1,25 do
				local dye = inv:get_stack("dye",i)
				if dye:get_name()~="default:leaves" and dye_table.sword[i]==1 then
					b=false
				end
				if dye:get_name()=="default:leaves" and dye_table.sword[i]==0 then
					b=false
				end
			end
			if b==true then res_craft="metals:recipe_sword" end
			
			if res_craft=="" then return end
			if inv:room_for_item("res",res_craft) then
				paperstack:take_item()
				inv:set_stack("paper", 1, paperstack)
				for i=1,25 do
					local dye = inv:get_stack("dye",i)
					dye:take_item()
					inv:set_stack("dye", i, dye)
				end
				inv:add_item("res", res_craft)
				return
			end
		end
	end,
})