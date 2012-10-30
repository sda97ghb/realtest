DISABLE_BLOCKS={
	--"default:desert_sand",
	--"default:desert_stone",
}

for i=1, #DISABLE_BLOCKS do
	minetest.register_node(":"..DISABLE_BLOCKS[i], {
		drawtype = "airlike",
		paramtype = "light",
		light_propagates = true,
		sunlight_propagates = true,
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		air_equivalent = true,
	})
end