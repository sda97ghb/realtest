buckets = {}
buckets.liquids = {}

realtest.registered_liquids = {}
function realtest.register_liquid(name, LiquidDef)
	if name and LiquidDef.source and LiquidDef.flowing and (LiquidDef.image_for_metal_bucket or LiquidDef.image_for_wood_bucket) then
		LiquidDef.name = name
		realtest.registered_liquids[LiquidDef.source] = LiquidDef
		realtest.registered_liquids[LiquidDef.flowing] = LiquidDef
	end
	if LiquidDef.image_for_metal_bucket then
		for i, metal in ipairs(metals.list) do
			minetest.register_craftitem("instruments:bucket_"..metal.."_with_"..LiquidDef.name, {
				description = metals.desc_list[i] .. " Bucket with " .. LiquidDef.description,
				inventory_image = "instruments_bucket_"..metal..".png^"..LiquidDef.image_for_metal_bucket,
				stack_max = 1,
				liquids_pointable = true,
				on_use = function(itemstack, user, pointed_thing)
					-- Must be pointing to node
					if pointed_thing.type ~= "node" then
						return
					end
					n = minetest.env:get_node(pointed_thing.under)
					if minetest.registered_nodes[n.name].buildable_to then
						minetest.env:add_node(pointed_thing.under, {name=LiquidDef.source})
					else
						n = minetest.env:get_node(pointed_thing.above)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.env:add_node(pointed_thing.above, {name=LiquidDef.source})
						else
							return
						end
					end
					return {name="instruments:bucket_"..metal}
				end
			})
		end
	end
	if LiquidDef.image_for_wood_bucket then
		for i, tree in pairs(realtest.registered_trees) do
			local wood = tree.name:remove_modname_prefix()
			minetest.register_craftitem("instruments:bucket_"..wood.."_with_"..LiquidDef.name, {
				description = "Empty " .. tree.description .. " Bucket with " .. LiquidDef.description,
				inventory_image = "instruments_bucket_wood.png^"..LiquidDef.image_for_wood_bucket,
				stack_max = 1,
				liquids_pointable = true,
				on_use = function(itemstack, user, pointed_thing)
					-- Must be pointing to node
					if pointed_thing.type ~= "node" then
						return
					end
					n = minetest.env:get_node(pointed_thing.under)
					if minetest.registered_nodes[n.name].buildable_to then
						minetest.env:add_node(pointed_thing.under, {name=LiquidDef.source})
					else
						n = minetest.env:get_node(pointed_thing.above)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.env:add_node(pointed_thing.above, {name=LiquidDef.source})
						else
							return
						end
					end
					return {name="instruments:bucket_"..wood}
				end,
			})
		end
	end
end

for i, metal in ipairs(metals.list) do
	minetest.register_craftitem("instruments:bucket_"..metal, {
		description = "Empty " .. metals.desc_list[i] .. " Bucket",
		inventory_image = "instruments_bucket_"..metal..".png",
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			n = minetest.env:get_node(pointed_thing.under)
			liquiddef = realtest.registered_liquids[n.name]
			if liquiddef and n.name == liquiddef.source then
				minetest.env:add_node(pointed_thing.under, {name="air"})
				return {name="instruments:bucket_"..wood}
			end
		end,
	})
end

for i, tree in pairs(realtest.registered_trees) do
	local wood = tree.name:remove_modname_prefix()
	minetest.register_craftitem("instruments:bucket_"..wood, {
		description = "Empty " .. tree.description .. " Bucket",
		inventory_image = "instruments_bucket_wood.png",
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			n = minetest.env:get_node(pointed_thing.under)
			liquiddef = realtest.registered_liquids[n.name]
			if liquiddef and n.name == liquiddef.source then
				minetest.env:add_node(pointed_thing.under, {name="air"})
				return {name="instruments:bucket_"..wood.."_with_"..liquiddef.name}
			end
		end,
	})
	minetest.register_craft({
		output = "instruments:bucket_"..wood,
		recipe = {
			{tree.name.."_plank", "", tree.name.."_plank"},
			{tree.name.."_plank", "", tree.name.."_plank"},
			{"", tree.name.."_plank", ""},
		},
	})
end

realtest.register_liquid("water", {
	description = "Water",
	source = "default:water_source",
	flowing = "default:water_flowing",
	image_for_metal_bucket = "instruments_metal_water.png",
	image_for_wood_bucket = "instruments_wood_water.png",
})

realtest.register_liquid("lava", {
	description = "Lava",
	source = "default:lava_source",
	flowing = "default:lava_flowing",
	image_for_metal_bucket = "instruments_lava.png",
})

