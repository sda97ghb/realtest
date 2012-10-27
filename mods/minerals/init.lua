MINERALS_LIST={
	'lapis',
	'anthracite',
	'brown_coal',
	'coal',
	'bituminous_coal',
	'magnetite',
	'hematite',
	'limonite',
	'bismuthinite',
	'cassiterite',
	'galena',
	'garnierite',
	'malachite',
	'native_copper',
	'native_gold',
	'native_platinum',
	'native_silver',
	'sphalerite',
	'tetrahedrite',
	'bauxite',
}

MINERALS_DESC_LIST={
	'Lapis',
	'Anthracite',
	'Brown coal',
	'Coal',
	'Bituminous coal',
	'Magnetite',
	'Hematite',
	'Limonite',
	'Bismuthinite',
	'Cassiterite',
	'Galena',
	'Garnierite',
	'Malachite',
	'Native copper',
	'Native gold',
	'Native platinum',
	'Native silver',
	'Sphalerite',
	'Tetrahedrite',
	'Bauxite',
}

for i=1, #MINERALS_LIST do
	minetest.register_craftitem("minerals:"..MINERALS_LIST[i], {
		description = MINERALS_DESC_LIST[i],
		inventory_image = "minerals_"..MINERALS_LIST[i]..".png",
	})
end

minetest.register_craftitem("minerals:flux", {
	description = "Flux",
	inventory_image = "minerals_flux.png",
})

minetest.register_craftitem("minerals:borax", {
	description = "Borax",
	inventory_image = "minerals_borax.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "minerals:flux 8",
	recipe = {"minerals:borax"},
})

-------------------------------------------------

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:brown_coal",
	burntime = 25,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:coal",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:anthracite",
	burntime = 50,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:bituminous_coal",
	burntime = 25,
})

minetest.register_craft({
	type="cooking",
	output="default:coal_lump 4",
	recipe="default:tree",
})

minetest.register_craft({
	type="cooking",
	output="default:coal_lump",
	recipe="default:wood",
})
