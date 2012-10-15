bucket = {}
bucket.liquids = {}

function bucket.register_liquid(source, flowing, itemname, inventory_image)

	bucket.liquids[source] = {
		source = source,
		flowing = flowing,
		itemname = itemname,
	}
	bucket.liquids[flowing] = bucket.liquids[source]

	if itemname ~= nil then
		for i = 1,#METALS_LIST do
			minetest.register_craftitem(itemname.."_"..i, {
				inventory_image = "metals_"..METALS_LIST[i].."_bucket.png^"..inventory_image,
				stack_max = 1,
				liquids_pointable = true,
				on_use = function(itemstack, user, pointed_thing)
					-- Must be pointing to node
					if pointed_thing.type ~= "node" then
						return
					end
					-- Check if pointing to a liquid
					n = minetest.env:get_node(pointed_thing.under)
					if bucket.liquids[n.name] == nil then
						-- Not a liquid
						--if minetest.env:get_node(pointed_thing.above) == "air" then
							minetest.env:add_node(pointed_thing.above, {name=source})
					--	end
					elseif n.name ~= source then
						-- It's a liquid
						minetest.env:add_node(pointed_thing.under, {name=source})
					end
					return {name="metals:bucket_empty_"..i}
				end
			})
		end
	end
end

for i = 1,#METALS_LIST do
	minetest.register_craftitem("metals:bucket_empty_"..i, {
		description = "Emtpy " .. DESC_LIST[i] .. " Bucket",
		inventory_image = "metals_"..METALS_LIST[i].."_bucket.png",
		stack_max = 1,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			-- Must be pointing to node
			if pointed_thing.type ~= "node" then
				return
			end
			-- Check if pointing to a liquid source
			n = minetest.env:get_node(pointed_thing.under)
			liquiddef = bucket.liquids[n.name]
			if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
				minetest.env:add_node(pointed_thing.under, {name="air"})
				return {name=liquiddef.itemname.."_"..i}
			end
		end,
	})
end

bucket.register_liquid(
	"default:water_source",
	"default:water_flowing",
	"metals:bucket_water",
	"metals_water.png"
)

bucket.register_liquid(
	"default:lava_source",
	"default:lava_flowing",
	"metals:bucket_lava",
	"metals_lava.png"
)
