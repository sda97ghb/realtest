buckets = {}
buckets.liquids = {}

function buckets.register_liquid(name, source, flowing, itemname, inventory_image)

	buckets.liquids[source] = {
		name = name,
		source = source,
		flowing = flowing,
		itemname = itemname,
	}
	buckets.liquids[flowing] = buckets.liquids[source]

	if itemname ~= nil then
		for i = 1,#metals.list do
			minetest.register_craftitem(itemname.."_"..metals.list[i], {
				description = metals.desc_list[i] .. " Bucket with " .. name,
				inventory_image = "instruments_bucket_"..metals.list[i]..".png^"..inventory_image,
				stack_max = 1,
				liquids_pointable = true,
				on_use = function(itemstack, user, pointed_thing)
					-- Must be pointing to node
					if pointed_thing.type ~= "node" then
						return
					end
					n = minetest.env:get_node(pointed_thing.under)
					if minetest.registered_nodes[n.name].buildable_to then
						minetest.env:add_node(pointed_thing.under, {name=source})
					else
						n = minetest.env:get_node(pointed_thing.above)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.env:add_node(pointed_thing.above, {name=source})
						else
							return
						end
					end
					return {name="instruments:bucket_empty_"..metals.list[i]}
				end
			})
		end
	end
end

for i = 1,#metals.list do
	minetest.register_craftitem("instruments:bucket_empty_"..metals.list[i], {
		description = "Empty " .. metals.desc_list[i] .. " Bucket",
		inventory_image = "instruments_bucket_"..metals.list[i]..".png",
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			-- Must be pointing to node
			if pointed_thing.type ~= "node" then
				return
			end
			-- Check if pointing to a liquid source
			n = minetest.env:get_node(pointed_thing.under)
			liquiddef = buckets.liquids[n.name]
			if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
				minetest.env:add_node(pointed_thing.under, {name="air"})
				return {name=liquiddef.itemname.."_"..metals.list[i]}
			end
		end,
	})
end

buckets.register_liquid(
	"Water",
	"default:water_source",
	"default:water_flowing",
	"instruments:bucket_water",
	"instruments_water.png"
)

buckets.register_liquid(
	"Lava",
	"default:lava_source",
	"default:lava_flowing",
	"instruments:bucket_lava",
	"instruments_lava.png"
)
