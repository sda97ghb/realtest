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
				inventory_image = "metals_"..metals.list[i].."_bucket.png^"..inventory_image,
				stack_max = 1,
				liquids_pointable = true,
				on_use = function(itemstack, user, pointed_thing)
					-- Must be pointing to node
					if pointed_thing.type ~= "node" then
						return
					end
					-- Check if pointing to a liquid
					n = minetest.env:get_node(pointed_thing.under)
					if buckets.liquids[n.name] == nil then
						-- Not a liquid
						if minetest.env:get_node(pointed_thing.above).name == "air" then
							minetest.env:add_node(pointed_thing.above, {name=source})
						else
							return itemstack
						end
					elseif n.name ~= source then
						-- It's a liquid
						minetest.env:add_node(pointed_thing.under, {name=source})
					end
					return {name="metals:bucket_empty_"..metals.list[i]}
				end
			})
		end
	end
end

for i = 1,#metals.list do
	minetest.register_craftitem("metals:bucket_empty_"..metals.list[i], {
		description = "Emtpy " .. metals.desc_list[i] .. " Bucket",
		inventory_image = "metals_"..metals.list[i].."_bucket.png",
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
	"metals:bucket_water",
	"metals_water.png"
)

buckets.register_liquid(
	"Lava",
	"default:lava_source",
	"default:lava_flowing",
	"metals:bucket_lava",
	"metals_lava.png"
)
