function minetest.item_place_node(itemstack, placer, pointed_thing)
	local item = itemstack:peek_item()
	local def = itemstack:get_definition()
	if def.type ~= "node" or pointed_thing.type ~= "node" then
		return itemstack
	end

	local under = pointed_thing.under
	local oldnode_under = minetest.env:get_node(under)
	local olddef_under = ItemStack({name=oldnode_under.name}):get_definition()
	olddef_under = olddef_under or minetest.nodedef_default
	local above = pointed_thing.above
	local oldnode_above = minetest.env:get_node(above)
	local olddef_above = ItemStack({name=oldnode_above.name}):get_definition()
	olddef_above = olddef_above or minetest.nodedef_default

	if not olddef_above.buildable_to and not olddef_under.buildable_to then
		minetest.log("info", placer:get_player_name() .. " tried to place"
			.. " node in invalid position " .. minetest.pos_to_string(above)
			.. ", replacing " .. oldnode_above.name)
		return
	end

	-- Place above pointed node
	local place_to = {x = above.x, y = above.y, z = above.z}

	-- If node under is buildable_to, place into it instead (eg. snow)
	if olddef_under.buildable_to then
		minetest.log("info", "node under is buildable to")
		place_to = {x = under.x, y = under.y, z = under.z}
	end

	minetest.log("action", placer:get_player_name() .. " places node "
		.. def.name .. " at " .. minetest.pos_to_string(place_to))
	
	local oldnode = minetest.env:get_node(place_to)
	local newnode = {name = def.name, param1 = 0, param2 = 0}

	-- Calculate direction for wall mounted stuff like torches and signs
	if def.paramtype2 == 'wallmounted' then
		local dir = {
			x = under.x - above.x,
			y = under.y - above.y,
			z = under.z - above.z
		}
		newnode.param2 = minetest.dir_to_wallmounted(dir)
	-- Calculate the direction for furnaces and chests and stuff
	elseif def.paramtype2 == 'facedir' then
		local placer_pos = placer:getpos()
		if placer_pos then
			local dir = {
				x = above.x - placer_pos.x,
				y = above.y - placer_pos.y,
				z = above.z - placer_pos.z
			}
			newnode.param2 = minetest.dir_to_facedir(dir)
			minetest.log("action", "facedir: " .. newnode.param2)
		end
	end

	-- Add node and update
	minetest.env:add_node(place_to, newnode)

	local take_item = true

	-- Run callback
	if def.after_place_node then
		-- Copy place_to because callback can modify it
		local place_to_copy = {x=place_to.x, y=place_to.y, z=place_to.z}
		if def.after_place_node(place_to_copy, placer, itemstack) then
			take_item = false
		end
	end

	-- Run script hook
	local _, callback
	for _, callback in ipairs(minetest.registered_on_placenodes) do
		-- Copy pos and node because callback can modify them
		local place_to_copy = {x=place_to.x, y=place_to.y, z=place_to.z}
		local newnode_copy = {name=newnode.name, param1=newnode.param1, param2=newnode.param2}
		local oldnode_copy = {name=oldnode.name, param1=oldnode.param1, param2=oldnode.param2}
		if callback(place_to_copy, newnode_copy, placer, oldnode_copy, itemstack) then
			take_item = false
		end
	end

	if take_item then
		itemstack:take_item()
	end
	return itemstack
end