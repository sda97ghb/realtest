minerals = {list={}}

function minerals.register_mineral(mineral, description, is_metal, metal)
	minetest.register_craftitem("minerals:"..mineral, {
		description = description,
		inventory_image = "minerals_"..mineral..".png",
	})

	if is_metal then
		minetest.register_node("minerals:"..mineral.."_block", {
			description = "Block of "..description,
			tiles = {"furnace_top_active.png"},
			particle_image = {"furnace_top_active.png"},
			groups = {falling_node=1},
		})

		minetest.register_craft({
			type = "shapeless",
			output = "minerals:"..mineral.."_block",
			recipe = {"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral,
					"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral,"minerals:"..mineral},
		})
		
		table.insert(minerals.list,{name=mineral, description=description, ismetal=true, metal=metal})
		return
	end
	table.insert(minerals.list,{name=mineral, description=description, ismetal=false})
end

minerals.register_mineral('lapis','Lapis',false)
minerals.register_mineral('anthracite','Anthracite',false)
minerals.register_mineral('lignite','Lignite',false)
minerals.register_mineral('bituminous_coal','Bituminous coal',false)
minerals.register_mineral('magnetite','Magnetite',true,'pig_iron')
minerals.register_mineral('hematite','Hematite',true,'pig_iron')
minerals.register_mineral('limonite','Limonite',true,'pig_iron')
minerals.register_mineral('bismuthinite','Bismuthinite',true,'bismuth')
minerals.register_mineral('cassiterite','Cassiterite',true,'tin')
minerals.register_mineral('galena','Galena',true,'lead')
minerals.register_mineral('garnierite','Garnierite',true,'nickel')
minerals.register_mineral('malachite','Malachite',true,'copper')
minerals.register_mineral('native_copper','Native copper',true,'copper')
minerals.register_mineral('native_gold','Native gold',true,'gold')
minerals.register_mineral('native_platinum','Native platinum',true,'platinum')
minerals.register_mineral('native_silver','Native silver',true,'silver')
minerals.register_mineral('sphalerite','Sphalerite',true,'zink')
minerals.register_mineral('tetrahedrite','Tetrahedrite',true,'copper')
minerals.register_mineral('bauxite','Bauxite',true,'aluminium')
minerals.register_mineral('cinnabar','Cinnabar',false)
minerals.register_mineral('cryolite','Cryolite',false)
minerals.register_mineral('graphite','Graphite',false)
minerals.register_mineral('gypsum','Gypsum',false)
minerals.register_mineral('jet','Jet',false)
minerals.register_mineral('kaolinite','Kaolinite',false)
minerals.register_mineral('kimberlite','Kimberlite',false)
minerals.register_mineral('olovine','Olovine',false)
minerals.register_mineral('petrified_wood','Petrified wood',false)
minerals.register_mineral('pitchblende','Pitchblende',false)
minerals.register_mineral('saltpeter','Saltpeter',false)
minerals.register_mineral('satinspar','Satinspar',false)
minerals.register_mineral('selenite','Selenite',false)
minerals.register_mineral('serpentine','Serpentine',false)
minerals.register_mineral('sulfur','Sulfur',false)
minerals.register_mineral('sylvite','Sylvite',false)
minerals.register_mineral('tenorite','Tenorite',false)

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
