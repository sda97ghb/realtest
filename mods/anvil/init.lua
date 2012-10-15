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
		{'default:stone','default:stone','default:stone'},
		{'','default:stone',''},
		{'default:stone','default:stone','default:stone'},
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
		meta:set_string("formspec", "invsize[8,7;]"..
				"button[0.5,0.25;2,1;buttonForge;Forge]"..
				"list[current_name;src1;2.9,0.25;1,1;]"..
				"image[3.69,0.22;0.54,1.5;anvil_arrow.png]"..
				"list[current_name;src2;4.1,0.25;1,1;]"..
				"button[5.5,0.25;2,1;buttonWeld;Weld]"..
				"list[current_name;hammer;1,1.5;1,1;]"..
				"list[current_name;res;3.5,1.5;1,1;]"..
				"list[current_name;borax;6,1.5;1,1;]"..
				"list[current_player;main;0,3;8,4;]")
		meta:set_string("infotext", "Anvil")
		local inv = meta:get_inventory()
		inv:set_size("src1", 1)
		inv:set_size("src2", 1)
		inv:set_size("hammer", 1)
		inv:set_size("res", 1)
		inv:set_size("borax", 1)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		if fields["forge"] then
			if inv:is_empty("hammer") or inv:is_empty("ingot") then
				return
			end
			
			local ingotstack = inv:get_stack("ingot", 1)
			local recipestack = inv:get_stack("recipe", 1)
			local hammerstack = inv:get_stack("hammer", 1)
			local resstack = inv:get_stack("res", 1)
			
			if table_containts(HAMMERS_LIST, hammerstack:get_name()) then
				local s = ingotstack:get_name()
				if not inv:is_empty("recipe") then
					if recipestack:get_name()=="metals:recipe_axe" then
						inv:add_item("res","metals:tool_axe_"..string.sub(s,8,string.len(s)-6).."_head")
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					elseif recipestack:get_name()=="metals:recipe_hammer" then
						inv:add_item("res","metals:tool_hammer_"..string.sub(s,8,string.len(s)-6).."_head")
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					elseif recipestack:get_name()=="metals:recipe_pick" then
						inv:add_item("res","metals:tool_pick_"..string.sub(s,8,string.len(s)-6).."_head")
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					elseif recipestack:get_name()=="metals:recipe_shovel" then
						inv:add_item("res","metals:tool_shovel_"..string.sub(s,8,string.len(s)-6).."_head")
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					elseif recipestack:get_name()=="metals:recipe_spear" then
						inv:add_item("res","metals:tool_spear_"..string.sub(s,8,string.len(s)-6).."_head")
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					elseif recipestack:get_name()=="metals:recipe_sword" then
						inv:add_item("res","metals:tool_sword_"..string.sub(s,8,string.len(s)-6).."_head")
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					elseif recipestack:get_name()=="metals:recipe_bucket" then
						inv:add_item("res","metals:bucket_empty_"..string.sub(s,8,string.len(s)-6))
						ingotstack:take_item()
						inv:set_stack("ingot",1,ingotstack)
						hammerstack:add_wear(65535/30)
						inv:set_stack("hammer",1,hammerstack)
					end
				end
				if ingotstack:get_name()=="metals:pig_iron_ingot" then
					inv:add_item("res","metals:wrought_iron_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
				elseif string.sub(ingotstack:get_name(), 1, 7)=="metals:" and string.sub(ingotstack:get_name(),-9,-1)=="_unshaped" then
					inv:add_item("res", "metals:"..string.sub(ingotstack:get_name(),8,-10).."_ingot")
					ingotstack:take_item()
					inv:set_stack("ingot",1,ingotstack)
					hammerstack:add_wear(65535/30)
					inv:set_stack("hammer",1,hammerstack)
				end
			end
		end
	end,
})
