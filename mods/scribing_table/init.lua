scribing_table = {}

realtest.registered_instrument_plans = {}
function realtest.register_instrument_plan(name, PlanDef)
	if PlanDef.bitmap then
		local plan = {
			name = name,
			description = PlanDef.description or "Plan",
			bitmap = PlanDef.bitmap,
			inventory_image = PlanDef.inventory_image or "scribing_table_plan.png",
			paper = PlanDef.paper or "default:paper"
		}
		minetest.register_craftitem(name, {
			description = plan.description,
			inventory_image = plan.inventory_image,
		})
		table.insert(realtest.registered_instrument_plans, plan)
	end
end

realtest.register_instrument_plan("scribing_table:plan_axe", {
	description = "Axe Plan",
	bitmap = {0,1,0,0,0,
		  1,1,1,1,0,
		  1,1,1,1,1,
		  1,1,1,1,0,
		  0,1,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_hammer", {
	description = "Hammer Plan",
	bitmap = {1,1,1,1,1,
		  1,1,1,1,1,
		  1,1,1,1,1,
		  0,0,1,0,0,
		  0,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_pick", {
	description = "Pick Plan",
	bitmap = {0,1,1,1,0,
		  1,0,0,0,1,
		  0,0,0,0,0,
		  0,0,0,0,0,
		  0,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_shovel", {
	description = "Shovel Plan",
	bitmap = {0,1,1,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,
		  0,0,1,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_spear", {
	description = "Spear Plan",
	bitmap = {1,1,0,0,0,
		  1,1,1,0,0,
		  0,1,0,0,0,
		  0,0,0,0,0,
		  0,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_sword", {
	description = "Sword Plan",
	bitmap = {0,0,0,1,1,
		  0,0,1,1,1,
		  0,1,1,1,0,
		  0,1,1,0,0,
		  1,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_bucket", {
	description = "Bucket Plan",
	bitmap = {1,0,0,0,1,
		  1,0,0,0,1,
		  1,0,0,0,1,
		  1,0,0,0,1,
		  0,1,1,1,0,}
})

realtest.register_instrument_plan("scribing_table:plan_chisel", {
	description = "Chisel Plan",
	bitmap = {0,0,1,0,0,
		  0,0,1,0,0,
		  0,0,1,0,0,
		  0,0,1,0,0,
		  0,0,1,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_lock", {
	description = "Lock Plan",
	bitmap = {0,1,1,1,0,
		  0,1,0,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,}
})

realtest.register_instrument_plan("scribing_table:plan_saw", {
	description = "Saw Plan",
	bitmap = {1,1,0,0,0,
		  1,1,1,0,0,
		  0,1,1,1,0,
		  0,1,1,1,1,
		  0,0,0,1,1,}
})

realtest.register_instrument_plan("scribing_table:stonebricks", {
	description = "Stonebricks Plan",
	bitmap = {1,1,1,1,1,
		  1,0,0,0,1,
		  1,1,1,1,1,
		  1,0,1,0,1,
		  1,1,1,1,1,}
})

realtest.register_instrument_plan("scribing_table:plan_hatch", {
	description = "Hatch Plan",
	bitmap = {1,1,1,1,1,
		  1,1,0,1,1,
		  1,0,1,0,1,
		  1,1,0,1,1,
		  1,1,1,1,1,}
})

local function check_recipe(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	for _, plan in pairs(realtest.registered_instrument_plans) do
		local paperstack, res_craft = inv:get_stack("paper", 1)
		if paperstack:get_name() == plan.paper then
			local f = true
			for j = 1,25 do
				local dye = inv:get_stack("dye", j)
				if  (minetest.registered_items[dye:get_name()].groups["dye"] == 1   and plan.bitmap[j] == 0) or
					(minetest.registered_items[dye:get_name()].groups["dye"] == nil and plan.bitmap[j] == 1) then
					f = false
					break
				end
			end
			if f then
				if inv:room_for_item("res", plan.name) then
					paperstack:take_item()
					inv:set_stack("paper", 1, paperstack)
					for i=1,25 do
						local dye = inv:get_stack("dye",i)
						dye:take_item()
						inv:set_stack("dye", i, dye)
					end
					inv:add_item("res", plan.name)
				end
				break
			end
		end
	end
end

for i, tree_name in ipairs(realtest.registered_trees_list) do
	local tree = realtest.registered_trees[tree_name]
	minetest.register_node("scribing_table:scribing_table_"..tree.name:remove_modname_prefix(), {
		description = tree.description.." Scribing Table",
		tiles = {tree.textures.planks.."^scribing_table_top.png", tree.textures.planks, tree.textures.planks.."^scribing_table_side.png"},
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
		sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("formspec", 
				"size[8,10]"..
				"list[current_name;paper;6.5,0.5;1,1;]"..
				"list[current_name;dye;0.5,0.5;5,5;]"..
				"list[current_name;res;6.5,4.5;1,1;]"..
				"image[5.5,1.5;2,3.4;scribing_table_arrow.png]"..
				"list[current_player;main;0,6;8,4;]"
			)
			meta:set_string("infotext", "Scribing Table")
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
	minetest.register_craft({
	output = "scribing_table:scribing_table_"..tree.name:remove_modname_prefix(),
	recipe = {
		{"","group:stick",""},
		{tree.name.."_plank","default:glass",tree.name.."_plank"},
		{tree.name.."_plank",tree.name.."_plank",tree.name.."_plank"},
	}
})
end
