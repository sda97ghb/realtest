minetest.register_node(":default:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2},
	drop = {
		max_items = 1,
		items = {
			{
				items = {'default:sapling'},
				rarity = 15,
			},
			{
				items = {'default:stick'},
				rarity = 10,
			},
			{
				items = {'default:leaves'},
			}
		}
	},
	climbable = true,
	sounds = default.node_sound_leaves_defaults(),
	walkable = false,
})
	
GROUND_LIST={
	'default:dirt',
	'default:dirt_with_grass',
}

local table_containts = function(t, v)
	for _, i in ipairs(t) do
		if i==v then
			return true
		end
	end
	return false
end

minetest.register_abm({
	nodenames = {'default:tree'},
	interval = 1.0,
	chance = 1.0,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if table_containts(GROUND_LIST, minetest.env:get_node({x = pos.x, y = pos.y-1, z = pos.z}).name) then return end
		for i = -1, 1 do
			for k = -1, 1 do
				if minetest.env:get_node({x = pos.x+i, y = pos.y-1, z = pos.z+k}).name == 'default:tree' then return end
			end
		end
		minetest.env:add_item(pos, "default:tree")
		minetest.env:add_node(pos, {name="air"})
	end,
})

minetest.register_abm({
	nodenames = {'default:tree'},
	interval = 3600000,
	chance = 0.1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		for i=0, 3 do
			for j=0,3 do
				for k=0,3 do
					if minetest.env:get_node({x=pos.x+i-1, y=pos.y+j-1, z=pos.z+k-1}).name == "air" then
						minetest.env:add_node({x=pos.x+i-1, y=pos.y+j-1, z=pos.z+k-1}, {name="default:apple"})
						return
					end
				end
			end
		end
	end,
})