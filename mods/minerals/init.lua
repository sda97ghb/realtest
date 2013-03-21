MINERALS_LIST={
	'lapis',
	'anthracite',
	'lignite',
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
	---------------------------
	'cinnabar',
	'cryolite',
	'galena',
	'garnierite',
	'graphite',
	'gypsum',
	'jet',
	'kaolinite',
	'kimberlite',
	'olovine',
	'petrified_wood',
	'pitchblende',
	'saltpeter',
	'satinspar',
	'selenite',
	'serpentine',
	'sulfur',
	'sylvite',
	'tenorite',
}

MINERALS_DESC_LIST={
	'Lapis',
	'Anthracite',
	'Lignite',
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
	---------------------------
	'Cinnabar',
	'Cryolite',
	'Galena',
	'Garnierite',
	'Graphite',
	'Gypsum',
	'Jet',
	'Kaolinite',
	'Kimberlite',
	'Olovine',
	'Petrified wood',
	'Pitchblende',
	'Saltpeter',
	'Satinspar',
	'Selenite',
	'Serpentine',
	'Sulfur',
	'Sylvite',
	'Tenorite',
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

minetest.register_craft({
	type = "shapeless",
	output = "minerals:flux 4",
	recipe = {"minerals:sylvite"},
})

-------------------------------------------------

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:lignite",
	burntime = 25,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:bituminous_coal",
	burntime = 35,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:anthracite",
	burntime = 50,
})

minetest.register_alias("minerals:brown_coal", "minerals:lignite")
