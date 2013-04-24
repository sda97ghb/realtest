mineralsi = {list={}}

function mineralsi.register_mineral(mineral, description, ore, metal)
	minetest.register_craftitem("minerals:"..mineral, {
		description = description,
		inventory_image = "minerals_"..mineral..".png",
	})

	if ore then
		minetest.register_node("minerals:"..mineral.."_block", {
			description = "Block of "..description,
			tiles = {"furnace_top_active.png"},
			particle_image = {"furnace_top_active.png"},
			groups = {falling_node=1,oddly_breakable_by_hand=1},
		})

		minetest.register_craft({
			type = "shapeless",
			output = "minerals:"..mineral.."_block",
			recipe = {"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral,
					"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral},
		})
		
		table.insert(mineralsi.list,{name=mineral, description=description, ore=true, metal=metal})
		return
	end
	table.insert(mineralsi.list,{name=mineral, description=description, ore=false, nil})
end

mineralsi.register_mineral('lapis','Lapis',false)
mineralsi.register_mineral('anthracite','Anthracite',false)
mineralsi.register_mineral('lignite','Lignite',false)
mineralsi.register_mineral('bituminous_coal','Bituminous coal',false)
mineralsi.register_mineral('magnetite','Magnetite',true,'pig_iron')
mineralsi.register_mineral('hematite','Hematite',true,'pig_iron')
mineralsi.register_mineral('limonite','Limonite',true,'pig_iron')
mineralsi.register_mineral('bismuthinite','Bismuthinite',true,'bismuth')
mineralsi.register_mineral('cassiterite','Cassiterite',true,'tin')
mineralsi.register_mineral('galena','Galena',true,'lead')
mineralsi.register_mineral('garnierite','Garnierite',true,'nickel')
mineralsi.register_mineral('malachite','Malachite',true,'copper')
mineralsi.register_mineral('native_copper','Native copper',true,'copper')
mineralsi.register_mineral('native_gold','Native gold',true,'gold')
mineralsi.register_mineral('native_platinum','Native platinum',true,'platinum')
mineralsi.register_mineral('native_silver','Native silver',true,'silver')
mineralsi.register_mineral('sphalerite','Sphalerite',true,'zink')
mineralsi.register_mineral('tetrahedrite','Tetrahedrite',true,'copper')
mineralsi.register_mineral('bauxite','Bauxite',true,'aluminium')
mineralsi.register_mineral('cinnabar','Cinnabar',false)
mineralsi.register_mineral('cryolite','Cryolite',false)
mineralsi.register_mineral('graphite','Graphite',false)
mineralsi.register_mineral('gypsum','Gypsum',false)
mineralsi.register_mineral('jet','Jet',false)
mineralsi.register_mineral('kaolinite','Kaolinite',false)
mineralsi.register_mineral('kimberlite','Kimberlite',false)
mineralsi.register_mineral('olovine','Olovine',false)
mineralsi.register_mineral('petrified_wood','Petrified wood',false)
mineralsi.register_mineral('pitchblende','Pitchblende',false)
mineralsi.register_mineral('saltpeter','Saltpeter',false)
mineralsi.register_mineral('satinspar','Satinspar',false)
mineralsi.register_mineral('selenite','Selenite',false)
mineralsi.register_mineral('serpentine','Serpentine',false)
mineralsi.register_mineral('sulfur','Sulfur',false)
mineralsi.register_mineral('sylvite','Sylvite',false)
mineralsi.register_mineral('tenorite','Tenorite',false)

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
