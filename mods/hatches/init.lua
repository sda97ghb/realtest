hatches = {}

function hatches.register_hatch(name, desc, is_wooden)

	local on_hatch_clicked = function(pos, node, puncher, itemstack)
		if node.name == "hatches:"..name.."_hatch_opened_top" then
			minetest.env:add_node(pos, {name = "hatches:"..name.."_hatch_closed", param2 = node.param2})
		elseif (node.name == "hatches:"..name.."_hatch_opened_bottom") and 
			(minetest.env:get_node({x = pos.x, y = pos.y  + 1, z = pos.z}).name == "air") then		
			minetest.env:add_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "hatches:"..name.."_hatch_closed", param2 = node.param2})
			minetest.env:remove_node(pos)
		elseif node.name == "hatches:"..name.."_hatch_closed" then
			if (minetest.env:get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name == "air") and (puncher:getpos().y + 1 >= pos.y) then
					minetest.env:add_node({x = pos.x, y = pos.y - 1, z = pos.z}, {name = "hatches:"..name.."_hatch_opened_bottom", 
						param2 = node.param2})
					minetest.env:remove_node(pos)
			else
				minetest.env:add_node(pos, {name = "hatches:"..name.."_hatch_opened_top", param2 = node.param2})
			end
		end
	end
	
	local texture 
	if is_wooden then
		texture = "trees_"..name.."_planks.png"
	else
		texture = "metals_"..name.."_block.png"
	end

	minetest.register_node("hatches:"..name.."_hatch_opened_top", {
		drawtype = "nodebox",
		tile_images = {texture},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		climbable = true,
		groups = {choppy=2, dig_immediate=2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, -0.3, 0.3, -0.4},
				{-0.5, 0.3, -0.5, 0.3, 0.5, -0.4},
				{0.3, -0.3, -0.5, 0.5, 0.5, -0.4},
				{0.5, -0.5, -0.5, -0.3, -0.3, -0.4},
				{-0.075, -0.3, -0.5, 0.075, 0.3, -0.4},
				{-0.3, -0.075, -0.5, -0.075, 0.075, -0.4},
				{0.075, -0.075, -0.5, 0.3, 0.075, -0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, -0.4},
		},
		drop = "hatches:"..name.."_hatch_closed",
		on_rightclick = function(pos, node, clicker, itemstack)
			on_hatch_clicked(pos, node, clicker, itemstack)
		end
	})

	minetest.register_node("hatches:"..name.."_hatch_closed", {
		description = desc.." Hatch",
		drawtype = "nodebox",
		tile_images = {texture},
		inventory_image = "hatches_"..name.."_hatch.png",
		wield_image = "hatches_"..name.."_hatch.png",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = {choppy=2, dig_immediate=2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.55, -0.5, -0.3, -0.45, 0.3},
				{-0.5, -0.55, 0.3, 0.3, -0.45, 0.5},
				{0.3, -0.55, -0.3, 0.5, -0.45, 0.5},
				{0.5, -0.55, -0.5, -0.3, -0.45, -0.3},
				{-0.075, -0.55, -0.3, 0.075, -0.45, 0.3},
				{-0.3, -0.55, -0.075, -0.075, -0.45, 0.075},
				{0.075, -0.55, -0.075, 0.3, -0.45, 0.075},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.55, -0.5, 0.5, -0.45, 0.5},
		},
		on_rightclick = function(pos, node, clicker, itemstack)
			on_hatch_clicked(pos, node, clicker, itemstack)
		end
	})

	minetest.register_node("hatches:"..name.."_hatch_opened_bottom", {
		drawtype = "nodebox",
		tile_images = {texture},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		climbable = true,
		groups = {choppy=2, dig_immediate=2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, -0.3, 0.3, -0.4},
				{-0.5, 0.3, -0.5, 0.3, 0.5, -0.4},
				{0.3, -0.3, -0.5, 0.5, 0.5, -0.4},
				{0.5, -0.5, -0.5, -0.3, -0.3, -0.4},
				{-0.075, -0.3, -0.5, 0.075, 0.3, -0.4},
				{-0.3, -0.075, -0.5, -0.075, 0.075, -0.4},
				{0.075, -0.075, -0.5, 0.3, 0.075, -0.4},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, -0.4},
		},
		drop = "hatches:"..name.."_hatch_closed",
		on_rightclick = function(pos, node, clicker, itemstack)
			on_hatch_clicked(pos, node, clicker, itemstack)
		end
	})

	if is_wooden then
		realtest.register_joiner_table_recipe({
			item1 = "trees:"..name.."_planks",
			item2 = "scribing_table:plan_hatch",
			output = "hatches:"..name.."_hatch_closed 2"
		})
	end

end

for i, metal_name in ipairs(metals.list) do
	hatches.register_hatch(metal_name, metals.desc_list[i])
end

for i, tree_name in ipairs(realtest.registered_trees_list) do
	local tree_desc = realtest.registered_trees[tree_name].description
	hatches.register_hatch(tree_name:remove_modname_prefix(), tree_desc, true)
end
