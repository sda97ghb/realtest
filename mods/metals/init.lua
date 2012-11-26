metals = {}

metals.levels = {0,0,0,1,2,2,2,2,2,2,2,2,2,2,3,3,3,4,4,5}

metals.list = {
	'bismuth',
	'zinc',
	'tin',
	----------
	'copper',
	----------
	'lead',
	'silver',
	'gold',
	'brass',
	'sterling_silver',
	'rose_gold',
	'black_bronze',
	'bismuth_bronze',
	'bronze',
	'aluminium',
	----------
	'platinum',
	'pig_iron',
	'wrought_iron',
	----------
	'nickel',
	'steel',
	----------
	'black_steel'
}

metals.desc_list = {
	'Bismuth',
	'Zinc',
	'Tin',
	----------
	'Copper',
	----------
	'Lead',
	'Silver',
	'Gold',
	'Brass',
	'Sterling Silver',
	'Rose Gold',
	'Black Bronze',
	'Bismuth Bronze',
	'Bronze',
	'Aluminium',
	----------
	'Platinum',
	'Pig Iron',
	'Wrought Iron',
	----------
	'Nickel',
	'Steel',
	----------
	'Black Steel'
}

for i=1, #metals.list do
	
	--
	-- Craftitems
	--
	
	minetest.register_craftitem("metals:"..metals.list[i].."_unshaped", {
		description = "Unshaped "..metals.desc_list[i],
		inventory_image = "metals_"..metals.list[i].."_unshaped.png",
	})
	
	minetest.register_craftitem("metals:"..metals.list[i].."_ingot", {
		description = metals.desc_list[i].." Ingot",
		inventory_image = "metals_"..metals.list[i].."_ingot.png",
	})
	
	minetest.register_craftitem("metals:"..metals.list[i].."_doubleingot", {
		description = metals.desc_list[i].." Double Ingot",
		inventory_image = "metals_"..metals.list[i].."_doubleingot.png",
	})
	
	minetest.register_craftitem("metals:"..metals.list[i].."_sheet", {
		description = metals.desc_list[i].." Sheet",
		inventory_image = "metals_" .. metals.list[i].."_sheet.png",
	})
	
	minetest.register_craftitem("metals:"..metals.list[i].."_doublesheet", {
		description = metals.desc_list[i].." Double Sheet",
		inventory_image = "metals_"..metals.list[i].."_doublesheet.png",
	})
	
	minetest.register_craftitem("metals:ceramic_mold_"..metals.list[i], {
		description = "Ceramic Mold with "..metals.desc_list[i],
		inventory_image = "metals_ceramic_mold.png^metals_"..metals.list[i].."_ingot.png",
	})
	
	minetest.register_craftitem("metals:"..metals.list[i].."_lock", {
		description = metals.desc_list[i].." Lock",
		inventory_image = "metals_"..metals.list[i].."_lock.png",
	})
	
	--
	-- Nodes
	--
	
	minetest.register_node("metals:"..metals.list[i].."_block", {
		description = "Block of "..metals.desc_list[i],
		tiles = {"metals_"..metals.list[i].."_block.png"},
		particle_image = {"metals_"..metals.list[i].."_block.png"},
		is_ground_content = true,
		drop = "metals:"..metals.list[i].."_doubleingot",
		groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})
	
	--
	-- Crafts
	--
	
	minetest.register_craft({
		output = "metals:"..metals.list[i].."_block",
		recipe = {
			{"metals:"..metals.list[i].."_doubleingot", "metals:"..metals.list[i].."_doubleingot"},
			{"metals:"..metals.list[i].."_doubleingot", "metals:"..metals.list[i].."_doubleingot"},
		}
	})
	
	minetest.register_craft({
		output = "metals:"..metals.list[i].."_ingot 4",
		recipe = {
			{"metals:"..metals.list[i].."_block"},
		}
	})
	
	minetest.register_craft({
		output = "metals:ceramic_mold_"..metals.list[i],
		recipe = {
			{"metals:"..metals.list[i].."_ingot"},
			{"metals:ceramic_mold"},
		}
	})
	
	--
	-- Cooking
	--
	
	minetest.register_craft({
		type = "cooking",
		output = "metals:"..metals.list[i].."_unshaped",
		recipe = "metals:ceramic_mold_"..metals.list[i],
	})
end

--
-- Smelting
--

minetest.register_craftitem("metals:clay_mold", {
	description = "Clay mold",
	inventory_image = "metals_clay_mold.png",
})

minetest.register_craftitem("metals:ceramic_mold", {
	description = "Ceramic mold",
	inventory_image = "metals_ceramic_mold.png",
})

minetest.register_craft({
	output = "metals:clay_mold 5",
	recipe = {
		{"default:clay_lump", "",                  "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump", "default:clay_lump"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "metals:ceramic_mold",
	recipe = "metals:clay_mold",
})

MINERALS_LIST={
	'magnetite',
	'hematite',
	'limonite',
	'bismuthinite',
	'cassiterite',
	'galena',
	'malachite',
	'native_copper',
	'native_gold',
	'native_platinum',
	'native_silver',
	'sphalerite',
	'tetrahedrite',
	'garnierite',
	'bauxite',
}

MINERALS_DESC_LIST={
	'magnetite',
	'hematite',
	'limonite',
	'bismuthinite',
	'cassiterite',
	'galena',
	'malachite',
	'native copper',
	'native gold',
	'native platinum',
	'native silver',
	'sphalerite',
	'tetrahedrite',
	'garnierite',
	'bauxite',
}

MINERALS_METALS_LIST={
	'pig_iron',
	'pig_iron',
	'pig_iron',
	'bismuth',
	'tin',
	'lead',
	'copper',
	'copper',
	'gold',
	'platinum',
	'silver',
	'zinc',
	'copper',
	'nickel',
	'aluminium',
}

for i=1, #MINERALS_LIST do
	minetest.register_craftitem("metals:ceramic_mold_"..MINERALS_LIST[i], {
		description = "Ceramic mold with "..MINERALS_DESC_LIST[i],
		inventory_image = "metals_ceramic_mold_"..MINERALS_LIST[i]..".png",
	})

	minetest.register_craft({
		output = "metals:ceramic_mold_"..MINERALS_LIST[i],
		recipe = {
			{"minerals:"..MINERALS_LIST[i]},
			{"metals:ceramic_mold"},
		}
	})

	minetest.register_craft({
		type = "cooking",
		output = "metals:"..MINERALS_METALS_LIST[i].."_unshaped",
		recipe = "metals:ceramic_mold_"..MINERALS_LIST[i],
	})
end

--
-- Alloys
--

minetest.register_craft({
	type = "shapeless",
	output = "metals:steel_unshaped 4",
	recipe = {"metals:wrought_iron_unshaped", "metals:wrought_iron_unshaped", "metals:wrought_iron_unshaped", "metals:pig_iron_unshaped"},
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:brass_unshaped 4",
	recipe = {"metals:copper_unshaped", "metals:copper_unshaped", "metals:copper_unshaped", "metals:zinc_unshaped"},
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:sterling_silver_unshaped 4",
	recipe = {"metals:silver_unshaped", "metals:silver_unshaped", "metals:silver_unshaped", "metals:copper_unshaped"},
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:rose_gold_unshaped 4",
	recipe = {"metals:gold_unshaped", "metals:gold_unshaped", "metals:gold_unshaped", "metals:brass_unshaped"},
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:black_bronze_unshaped 4",
	recipe = {"metals:copper_unshaped", "metals:copper_unshaped", "metals:gold_unshaped", "metals:silver_unshaped"},
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:bismuth_bronze_unshaped 4",
	recipe = {"metals:copper_unshaped", "metals:copper_unshaped", "metals:bismuth_unshaped", "metals:tin_unshaped"}
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:bronze_unshaped 4",
	recipe = {"metals:copper_unshaped", "metals:copper_unshaped", "metals:copper_unshaped", "metals:tin_unshaped"}
})

minetest.register_craft({
	type = "shapeless",
	output = "metals:black_steel_unshaped 4",
	recipe = {"metals:steel_unshaped", "metals:steel_unshaped", "metals:nickel_unshaped", "metals:black_bronze_unshaped"}
})

--
-- Other
--
