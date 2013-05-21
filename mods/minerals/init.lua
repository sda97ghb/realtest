mineralsi = {list={}}

function mineralsi.register_mineral(mineral, description, ore, metal)
	minetest.register_craftitem("minerals:"..mineral, {
		description = description,
		inventory_image = "minerals_"..mineral..".png",
	})

	if ore then
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
mineralsi.register_mineral('skutterudite','Skutterudite',true,'cobalt')
mineralsi.register_mineral('cobaltite','Cobaltite',true,'cobalt')
mineralsi.register_mineral('malachite','Malachite',true,'copper')
mineralsi.register_mineral('native_copper','Native copper',true,'copper')
mineralsi.register_mineral('native_gold','Native gold',true,'gold')
mineralsi.register_mineral('native_platinum','Native platinum',true,'platinum')
mineralsi.register_mineral('native_silver','Native silver',true,'silver')
mineralsi.register_mineral('sphalerite','Sphalerite',true,'zink')
mineralsi.register_mineral('tetrahedrite','Tetrahedrite',true,'copper')
mineralsi.register_mineral('bauxite','Bauxite',true,'aluminium')
mineralsi.register_mineral('scheelite','Scheelite',true,'tungsten')
mineralsi.register_mineral('wolframite','Wolframite',true,'tungsten')
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

minetest.register_abm({
	nodenames = {"coke:lignite_block"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local b = false
		if minetest.env:get_node({x=pos.x+1, y=pos.y, z=pos.z}).name == 'air' then b=true end
		if minetest.env:get_node({x=pos.x-1, y=pos.y, z=pos.z}).name == 'air' then b=true end
		if minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z+1}).name == 'air' then b=true end
		if minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z-1}).name == 'air' then b=true end
		if b then
			minetest.env:remove_node(pos);
			minetest.env:add_item(pos, "minerals:bituminous_coal 4")
			nodeupdate(pos)
		end
	end
})

minetest.register_abm({
	nodenames = {"coke:bituminous_coal_block"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local b = false
		if minetest.env:get_node({x=pos.x+1, y=pos.y, z=pos.z}).name == 'air' then b=true end
		if minetest.env:get_node({x=pos.x-1, y=pos.y, z=pos.z}).name == 'air' then b=true end
		if minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z+1}).name == 'air' then b=true end
		if minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z-1}).name == 'air' then b=true end
		if b then
			minetest.env:remove_node(pos);
			minetest.env:add_item(pos, "minerals:bituminous_coal 4")
			nodeupdate(pos)
		end
	end
})

minetest.register_abm({
	nodenames = {"coke:bituminous_coal_block","coke:lignite_block","default:brick","coke:coke_block",
		"default:stone_flat","default:desert_stone_flat","default:cobbleblock_flat"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
-- 		local b = true
-- 		if minetest.env:get_node({x=pos.x+1, y=pos.y+1, z=pos.z}).name == 'air' then b=false end
-- 		if minetest.env:get_node({x=pos.x-1, y=pos.y+1, z=pos.z}).name == 'air' then b=false end
-- 		if minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z+1}).name == 'air' then b=false end
-- 		if minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z-1}).name == 'air' then b=false end
-- 		if b then
		local p = {x=pos.x, y=pos.y+1, z=pos.z}
		local objects = minetest.env:get_objects_inside_radius(p, 0.5)
		local lignite = 0
		local coals = {}
		for _, v in ipairs(objects) do
			if not v:is_player() and v:get_luaentity() and v:get_luaentity().name == "__builtin:item" then
				local istack = ItemStack(v:get_luaentity().itemstring)
				if istack:get_name() == "minerals:lignite" then
					lignite = lignite + istack:get_count()
					table.insert(coals,v)
				end
			end
		end
		if minetest.env:get_node(p).name == "air" and lignite ==4 then
			for _, v in ipairs(coals) do
				v:remove()
			end
			minetest.env:set_node(p, {name = "coke:lignite_block"})
			--[[if lignite-4 > 0 then
				lignite = lignite - 4
				minetest.env:add_item({x=pos.x, y=pos.y+2, z=pos.z},"minerals:lignite "..lignite)
			end]]
			return
		end
		local bituminous_coal = 0
		local coals = {}
		for _, v in ipairs(objects) do
			if not v:is_player() and v:get_luaentity() and v:get_luaentity().name == "__builtin:item" then
				local istack = ItemStack(v:get_luaentity().itemstring)
				if istack:get_name() == "minerals:bituminous_coal" then
					bituminous_coal = bituminous_coal + istack:get_count()
					table.insert(coals,v)
				end
			end
		end
		if minetest.env:get_node(p).name == "air" and bituminous_coal ==4 then
			for _, v in ipairs(coals) do
				v:remove()
			end
			minetest.env:set_node(p, {name = "coke:bituminous_coal_block"})
			--[[if bituminous_coal-4 > 0 then
				bituminous_coal = bituminous_coal - 4
				minetest.env:add_item({x=pos.x, y=pos.y+2, z=pos.z},"minerals:lignite "..bituminous_coal)
			end]]
		end
-- 		end
	end
})

minetest.register_alias("minerals:brown_coal", "minerals:lignite")