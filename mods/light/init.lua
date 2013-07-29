minetest.register_node("light:streetlight", {
	description = "Streetlight",
	drawtype = "nodebox",
	tiles = {"light_streetlight_top.png", "light_streetlight_top.png", "light_streetlight.png",},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 14,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.35, -0.375, -0.35, 0.35, 0.375, 0.35},
			{-0.2, -0.5, -0.2, 0.2, 0.5, 0.2},
		},
	},
	groups = {choppy=2,dig_immediate=3,flammable=1},
})

metals = {"pig_iron", "bronze"}
fuels = {"charcoal", "anthracite", "bituminous_coal", "lignite"}

for _, metal in ipairs(metals) do
	for _, fuel in ipairs(fuels) do
		minetest.register_craft({
			output = "light:streetlight",
			recipe = {
				{"metals:"..metal.."_sheet"},
				{"minerals:"..fuel},
				{"metals:"..metal.."_sheet"},
			}
		})
	end
end