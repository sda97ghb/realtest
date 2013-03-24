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
		output = name.."_stair 8",
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
		groups.not_in_creative_inventory = 1
		images = images or minetest.registered_nodes[name].tiles
		description = description or minetest.registered_nodes[name].description .. " Slab"
		sounds = sounds or minetest.registered_nodes[name].sounds
	else
		if not (recipeitem and groups and images and description and sounds) then
			return
		end
	end
	drop = drop or name.."_slab"
	minetest.register_node(":"..name.."_slab_r", {
		drawtype = "nodebox",
		tiles = images,
		drop = drop,
		paramtype = "light",
		paramtype2 = "wallmounted",
		groups = groups,
		sounds = sounds,
		node_box = {
			type = "wallmounted",
			wall_bottom = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			wall_top = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
			wall_side = {-0.5, -0.5, -0.5, 0, 0.5, 0.5},
		},
		selection_box = {
			type = "wallmounted",
			wall_bottom = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			wall_top = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
			wall_side = {-0.5, -0.5, -0.5, 0, 0.5, 0.5},
		}
	})
	groups.not_in_creative_inventory = 0
	minetest.register_node(":"..name.."_slab", {
		description = description,
		drawtype = "nodebox",
		groups = groups,
		tiles = images,
		paramtype = "light",
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
			local p1 = pointed_thing.under
			local p2 = pointed_thing.above
			local dir = {x=p1.x-p2.x,y=p1.y-p2.y,z=p1.z-p2.z}
			if (minetest.env:get_node(pointed_thing.under).name == name.."_slab_r"
				and minetest.env:get_node(pointed_thing.under).param2 == minetest.dir_to_wallmounted(dir)) or
					(minetest.env:get_node(pointed_thing.under).name == name.."_slab"
					and minetest.env:get_node(pointed_thing.under).param2 == 0) then
				minetest.env:set_node(pointed_thing.under, {name=name})
			elseif minetest.registered_nodes[minetest.env:get_node(pointed_thing.above).name].buildable_to then
				minetest.env:set_node(pointed_thing.above, {name=name.."_slab_r", param2=minetest.dir_to_wallmounted(dir)})
			else
				return itemstack
			end
			
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})

	minetest.register_craft({
		output = name.."_slab 6",
		recipe = {
			{recipeitem, recipeitem, recipeitem},
		},
	})
	minetest.register_alias(name.."_slab_upside_down", name.."_slab_r")
end

function realtest.register_stair_and_slab(name, recipeitem, groups, images, description, sounds, drop)
	realtest.register_stair(name, recipeitem, groups, images, description, sounds, drop)
	realtest.register_slab(name, recipeitem, groups, images, description, sounds, drop)
end