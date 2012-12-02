snow = {}
snow.interval = 60
snow.chance = 5

for i = 1, 10 do
	minetest.register_node("snow:self_"..i,{
		description = "Snow",
		tiles = {"snow_self.png"},
		particle_image = {"snow_self.png"},
		is_ground_content = true,
		groups = {snow=1,crumbly=3,falling_node=1,not_in_creative_inventory=1,drop_on_dig=1},
		sounds = default.node_sound_sand_defaults(),
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,-0.5+i/10,0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,-0.5+i/10,0.5},
			},
		},
		drop = "snow:snowball "..i-1,
	})
	
	if i<10 then
		minetest.register_abm({
			nodenames = {"snow:self_"..i},
			interval = snow.interval,
			chance = snow.chance,
			action = function(pos, node)
				if seasons.get_season() == seasons.seasons[4] then
					minetest.env:set_node(pos,{name = "snow:self_"..i+1})
				end
			end,
		})
	end
end

minetest.register_abm({
	nodenames = {"group:snow"},
	interval = snow.interval,
	chance = 2,
	action = function(pos, node)
		if seasons.get_season() ~= seasons.seasons[4] then
			local n = tonumber(node.name:sub(-1)) - 1
			minetest.chat_send_all(node.name)
			if n ~= 0 then
				minetest.env:set_node(pos, {name = "snow:self_"..n})
			else
				minetest.env:set_node(pos, {name = "air"})
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	interval = snow.interval,
	chance = 2,
	action = function(pos, node)
		if seasons.get_season() == seasons.seasons[4] then
			set_node_instead_air({x=pos.x, y=pos.y + 1, z=pos.z}, {name = "snow:self_1"})
		end
	end,
})

minetest.register_craftitem("snow:snowball", {
	description = "Snowball",
	inventory_image = "snow_snowball.png",
})

minetest.register_craft({
	output = "snow:self_10",
	recipe = {
		{"snow:snowball","snow:snowball","snow:snowball"},
		{"snow:snowball","snow:snowball","snow:snowball"},
		{"snow:snowball","snow:snowball","snow:snowball"},
	}
})