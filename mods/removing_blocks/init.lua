removing_blocks = {}
removing_blocks.blocks = {
	"default:tree",
	"default:leaves",
}
for i, block in ipairs(removing_blocks.blocks) do
	minetest.register_node(":"..block, {
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
