anvil = {}

HAMMERS_LIST={
	'anvil:hammer',
	'metals:tool_hammer_bismuth',
	'metals:tool_hammer_pig_iron',
	'metals:tool_hammer_wrought_iron',
	'metals:tool_hammer_steel',
	'metals:tool_hammer_gold',
	'metals:tool_hammer_nickel',
	'metals:tool_hammer_platinum',
	'metals:tool_hammer_tin',
	'metals:tool_hammer_silver',
	'metals:tool_hammer_lead',
	'metals:tool_hammer_copper',
	'metals:tool_hammer_zinc',
	'metals:tool_hammer_brass',
	'metals:tool_hammer_sterling_silver',
	'metals:tool_hammer_rose_gold',
	'metals:tool_hammer_black_bronze',
	'metals:tool_hammer_bismuth_bronze',
	'metals:tool_hammer_bronze',
	'metals:tool_hammer_black_steel',
}

local table_containts = function(t, v)
	for _, i in ipairs(t) do
		if i==v then
			return true
		end
	end
	return false
end

minetest.register_craft({
	output = 'anvil:self',
	recipe = {
		{'default:cobble','default:cobble','default:cobble'},
		{'','default:cobble',''},
		{'default:cobble','default:cobble','default:cobble'},
	}
})

minetest.register_craft({
	output = 'anvil:hammer',
	recipe = {
		{'default:cobble','default:cobble','default:cobble'},
		{'default:cobble','default:stick','default:cobble'},
		{'','default:stick',''},
	}
})

minetest.register_tool("anvil:hammer", {
	description = "Hammer",
	inventory_image = "anvil_hammer.png",
	tool_capabilities = {
		max_drop_level=1,
		groupcaps={
			cracky={times={[1]=6.00, [2]=4.30, [3]=3.00}, uses=20, maxlevel=1},
			fleshy={times={[1]=2.00, [2]=0.80, [3]=0.40}, uses=10, maxlevel=2},
		}
	},
})

minetest.register_node("anvil:self", {
	description = "Anvil",
	tiles = {"anvil_top.png","anvil_top.png","anvil_side.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
			{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
			{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
			{-0.35,-0.1,-0.2,0.35,0.1,0.2},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
			{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
			{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
			{-0.35,-0.1,-0.2,0.35,0.1,0.2},
		},
	},
	groups = {oddly_breakable_by_hand=2, cracky=3, dig_immediate=1},
	sounds = default.node_sound_stone_defaults(),
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("hammer") then
			return false
		elseif not inv:is_empty("ingot") then
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
				"list[current_name;hammer;1,3.5;1,1;]"..
				"list[current_name;ingot;1,1.5;1,1;]"..
				"list[current_name;recipe;6,1.5;1,1;]"..
				"list[current_name;res;3,1.5;1,1;]"..
				"label[1,1;Ingot:]"..
				"label[6,1;Recipe:]"..
				"label[3,1;Output:]"..
				"label[1,3;Hammer:]"..
				"button[4,2.5;2,3;forge;Forge]"..
				"list[current_player;main;0,6;8,4;]")
		meta:set_string("infotext", "Anvil")
		local inv = meta:get_inventory()
		inv:set_size("hammer", 1)
		inv:set_size("ingot", 1)
		inv:set_size("recipe", 1)
		inv:set_size("res", 1)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		if fields["forge"] then
			if inv:is_empty("hammer") or inv:is_empty("ingot") or inv:is_empty("recipe") then
				return
			end
			
			local ingotstack = inv:get_stack("ingot", 1)
			local recipestack = inv:get_stack("recipe", 1)
			local hammerstack = inv:get_stack("hammer", 1)
			local resstack = inv:get_stack("res", 1)
			
			if table_containts(HAMMERS_LIST, hammerstack:get_name()) then
				local s = ingotstack:get_name()
				if recipestack:get_name()=="metals:recipe_axe" then
					inv:add_item("res","metals:tool_axe_"..string.sub(s,8,string.len(s)-6).."_head")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif recipestack:get_name()=="metals:recipe_hammer" then
					inv:add_item("res","metals:tool_hammer_"..string.sub(s,8,string.len(s)-6).."_head")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif recipestack:get_name()=="metals:recipe_pick" then
					inv:add_item("res","metals:tool_pick_"..string.sub(s,8,string.len(s)-6).."_head")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif recipestack:get_name()=="metals:recipe_shovel" then
					inv:add_item("res","metals:tool_shovel_"..string.sub(s,8,string.len(s)-6).."_head")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif recipestack:get_name()=="metals:recipe_spear" then
					inv:add_item("res","metals:tool_spear_"..string.sub(s,8,string.len(s)-6).."_head")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif recipestack:get_name()=="metals:recipe_sword" then
					inv:add_item("res","metals:tool_sword_"..string.sub(s,8,string.len(s)-6).."_head")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif ingotstack:get_name()=="metals:pig_iron_ingot" then
					inv:add_item("res","metals:wrought_iron_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				--moreores
				elseif ingotstack:get_name()=="metals:gold_ingot" and minetest.get_modpath("moreores") ~= nil then
					inv:add_item("res","moreores:gold_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif ingotstack:get_name()=="metals:silver_ingot" and minetest.get_modpath("moreores") ~= nil then
					inv:add_item("res","moreores:silver_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif ingotstack:get_name()=="metals:tin_ingot" and minetest.get_modpath("moreores") ~= nil then
					inv:add_item("res","moreores:tin_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif ingotstack:get_name()=="metals:copper_ingot" and minetest.get_modpath("moreores") ~= nil then
					inv:add_item("res","moreores:copper_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				elseif ingotstack:get_name()=="metals:bronze_ingot" and minetest.get_modpath("moreores") ~= nil then
					ingotstack:take_item()
					inv:add_item("res","moreores:bronze_ingot")
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return
				--[[elseif string.sub(ingotstack:get_name(), 1, 6)=="metals" and string.sub(ingotstack:get_name(),string.len(ingotstack:get_name())-9,9)=="_unshaped" then
					inv:add_item("res", "metals:"..string.sub(ingotstack:get_name(),7,string.len(ingotstack:get_name())-13).."_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
					return]]
				end
			end
		end
	end,
})
