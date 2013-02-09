function realtest.register_stair(name, recipeitem, groups, images, description, sounds, drop)
	if minetest.registered_nodes[name] then
		recipeitem = recipeitem or name
		groups = groups or minetest.registered_nodes[name].groups
		images = images or minetest.registered_nodes[name].tiles
		description = description or minetest.registered_nodes[name].description .. " Stair"
		sounds = sounds or minetest.registered_nodes[name].sounds
	else
		if not (recipeitem and groups and images and description and sounds) then
			return
		end
	end
	drop = drop or name.."_stair"
	minetest.register_node(":"..name.."_stair", {
		description = description,
		drawtype = "nodebox",
		tiles = images,
		drop = drop,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			
			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			if p0.y-1 == p1.y then
				local fakestack = ItemStack(name.."_stair".."_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret and ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end
			
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})
	
	minetest.register_node(":"..name.."_stair_upside_down", {
		drop = drop,
		drawtype = "nodebox",
		tiles = images,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, 0, 0.5, 0, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, 0, 0.5, 0, 0.5},
			},
		},
	})

	minetest.register_craft({
		output = name.."_stair 8",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	minetest.register_craft({
		output = name.."_stair 4",
		recipe = {
			{"", "", recipeitem},
			{"", recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem},
		},
	})
end

function realtest.register_slab(name, recipeitem, groups, images, description, sounds, drop)
	if minetest.registered_nodes[name] then
		recipeitem = recipeitem or name
		groups = groups or minetest.registered_nodes[name].groups
		images = images or minetest.registered_nodes[name].tiles
		description = description or minetest.registered_nodes[name].description .. " Slab"
		sounds = sounds or minetest.registered_nodes[name].sounds
	else
		if not (recipeitem and groups and images and description and sounds) then
			return
		end
	end
	drop = drop or name.."_slab"
	minetest.register_node(":"..name.."_slab", {
		description = description,
		drawtype = "nodebox",
		tiles = images,
		drop = drop,
		paramtype = "light",
		groups = groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			-- If it's being placed on an another similar one, replace it with
			-- a full block
			local slabpos = nil
			local slabnode = nil
			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local n0 = minetest.env:get_node(p0)
			if n0.name == name.."_slab" and
					p0.y+1 == p1.y then
				slabpos = p0
				slabnode = n0
			end
			if slabpos then
				-- Remove the slab at slabpos
				minetest.env:remove_node(slabpos)
				-- Make a fake stack of a single item and try to place it
				local fakestack = ItemStack(recipeitem)
				pointed_thing.above = slabpos
				fakestack = minetest.item_place(fakestack, placer, pointed_thing)
				-- If the item was taken from the fake stack, decrement original
				if not fakestack or fakestack:is_empty() then
					itemstack:take_item(1)
				-- Else put old node back
				else
					minetest.env:set_node(slabpos, slabnode)
				end
				return itemstack
			end
			
			-- Upside down slabs
			if p0.y-1 == p1.y then
				-- Turn into full block if pointing at a existing slab
				if n0.name == name.."_slab_upside_down" then
					-- Remove the slab at the position of the slab
					minetest.env:remove_node(p0)
					-- Make a fake stack of a single item and try to place it
					local fakestack = ItemStack(recipeitem)
					pointed_thing.above = p0
					fakestack = minetest.item_place(fakestack, placer, pointed_thing)
					-- If the item was taken from the fake stack, decrement original
					if not fakestack or fakestack:is_empty() then
						itemstack:take_item(1)
					-- Else put old node back
					else
						minetest.env:set_node(p0, n0)
					end
					return itemstack
				end
				
				-- Place upside down slab
				local fakestack = ItemStack(name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret and ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end
			
			-- If pointing at the side of a upside down slab
			if n0.name == name.."_slab_upside_down" and
					p0.y+1 ~= p1.y then
				-- Place upside down slab
				local fakestack = ItemStack(name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret and ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end
			
			-- Otherwise place regularly
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})
	
	minetest.register_node(":"..name.."_slab_upside_down", {
		drop = drop,
		drawtype = "nodebox",
		tiles = images,
		paramtype = "light",
		groups = groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
		},
	})

	minetest.register_craft({
		output = name.."_slab 6",
		recipe = {
			{recipeitem, recipeitem, recipeitem},
		},
	})
end

function realtest.register_stair_and_slab(name, recipeitem, groups, images, description, sounds, drop)
	realtest.register_stair(name, recipeitem, groups, images, description, sounds, drop)
	realtest.register_slab(name, recipeitem, groups, images, description, sounds, drop)
end