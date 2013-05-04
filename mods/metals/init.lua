metals = {}
metals.metals={}
metals.list={}
metals.desc_list={}
metals.levels={}

function realtest.register_metal(name, description, level)
	local metal = {
		name = name or "",
		description = description or "",
		level = level or "",
	}
	
	table.insert(metals.metals,metal)
	table.insert(metals.list,name)
	table.insert(metals.desc_list,description)
	table.insert(metals.levels,level)
	
	--
	-- Craftitems
	--
	
	minetest.register_craftitem("metals:"..name.."_unshaped", {
		description = "Unshaped "..description,
		inventory_image = "metals_"..name.."_unshaped.png",
	})
	
	minetest.register_craftitem("metals:"..name.."_ingot", {
		description = description.." Ingot",
		inventory_image = "metals_"..name.."_ingot.png",
	})
	
	minetest.register_craftitem("metals:"..name.."_doubleingot", {
		description = description.." Double Ingot",
		inventory_image = "metals_"..name.."_doubleingot.png",
	})
	
	minetest.register_craftitem("metals:"..name.."_sheet", {
		description = description.." Sheet",
		inventory_image = "metals_"..name.."_sheet.png",
	})
	
	minetest.register_craftitem("metals:"..name.."_doublesheet", {
		description = description.." Double Sheet",
		inventory_image = "metals_"..name.."_doublesheet.png",
	})
	
	minetest.register_craftitem("metals:ceramic_mold_"..name, {
		description = "Ceramic Mold with "..description,
		inventory_image = "metals_ceramic_mold.png^metals_"..name.."_ingot.png",
	})
	
	minetest.register_craftitem("metals:"..name.."_lock", {
		description = description.." Lock",
		inventory_image = "metals_"..name.."_lock.png",
	})
	
	--
	-- Nodes
	--
	
	minetest.register_node("metals:"..name.."_block", {
		description = "Block of "..description,
		tiles = {"metals_"..name.."_block.png"},
		particle_image = {"metals_"..name.."_block.png"},
		is_ground_content = true,
		drop = "metals:"..name.."_doubleingot 4",
		groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})
	
	--
	-- Crafts
	--
	
	minetest.register_craft({
		output = "metals:"..name.."_block",
		recipe = {
			{"metals:"..name.."_doubleingot", "metals:"..name.."_doubleingot"},
			{"metals:"..name.."_doubleingot", "metals:"..name.."_doubleingot"},
		}
	})
	
	realtest.register_stair("metals:"..name.."_block",nil,nil,nil,description.." Stair",nil,
			"metals:"..name.."_doubleingot 3")
	realtest.register_slab("metals:"..name.."_block",nil,nil,nil,description.." Slab",nil,
			"metals:"..name.."_doubleingot 2")
	minetest.register_craft({
		output = "metals:"..name.."_block_slab",
		recipe = {
			{"metals:"..name.."_doubleingot","metals:"..name.."_doubleingot"},
		},
	})
	minetest.register_craft({
		output = "metals:"..name.."_block_stair",
		recipe = {
			{"metals:"..name.."_doubleingot",""},
			{"metals:"..name.."_doubleingot","metals:"..name.."_doubleingot"},
		},
	})
	minetest.register_craft({
		output = "metals:"..name.."_block_stair",
		recipe = {
			{"","metals:"..name.."_doubleingot"},
			{"metals:"..name.."_doubleingot","metals:"..name.."_doubleingot"},
		},
	})
	
	minetest.register_craft({
		output = "metals:ceramic_mold_"..name,
		recipe = {
			{"metals:"..name.."_ingot"},
			{"metals:ceramic_mold"},
		}
	})
	
	minetest.register_craft({
		output = "metals:"..name.."_ingot",
		recipe = {{"metals:ceramic_mold_"..name}},
		replacements = {{"metals:ceramic_mold_"..name, "metals:ceramic_mold"}},
	})
	
	--
	-- Cooking
	--
	
	minetest.register_craft({
		type = "cooking",
		output = "metals:"..name.."_unshaped",
		recipe = "metals:ceramic_mold_"..name,
	})
end

function realtest.register_smelting(mineral, mineral_desc, metal)
	minetest.register_craftitem("metals:ceramic_mold_"..mineral, {
		description = "Ceramic mold with "..mineral_desc,
		inventory_image = "metals_ceramic_mold_"..mineral..".png",
	})

	minetest.register_craft({
		output = "metals:ceramic_mold_"..mineral,
		recipe = {
			{"minerals:"..mineral},
			{"metals:ceramic_mold"},
		}
	})
	
	minetest.register_craft({
		output = "minerals:"..mineral,
		recipe = {{"metals:ceramic_mold_"..mineral}},
		replacements = {{"metals:ceramic_mold_"..mineral, "metals:ceramic_mold"}},
	})

	minetest.register_craft({
		type = "cooking",
		output = "metals:"..metal.."_unshaped",
		recipe = "metals:ceramic_mold_"..mineral,
	})
end

function realtest.register_alloy(output,recipe)
	minetest.register_craft({
		type = "shapeless",
		output = output or "",
		recipe = recipe or "",
	})
end

realtest.register_metal('bismuth', 'Bismuth', 0)
realtest.register_metal('zinc','Zinc',0)
realtest.register_metal('tin','Tin',0)
realtest.register_metal('copper','Copper',1)
realtest.register_metal('lead','Lead',2)
realtest.register_metal('silver','Silver',2)
realtest.register_metal('gold','Gold',2)
realtest.register_metal('brass','Brass',2)
realtest.register_metal('sterling_silver','Sterling silver',2)
realtest.register_metal('rose_gold','Rose Gold',2)
realtest.register_metal('black_bronze','Black Bronze',2)
realtest.register_metal('bismuth_bronze','Bismuth Bronze',2)
realtest.register_metal('bronze','Bronze',2)
realtest.register_metal('aluminium','Aluminium',2)
realtest.register_metal('platinum','Platinum',3)
realtest.register_metal('pig_iron','Pig Iron',3)
realtest.register_metal('wrought_iron','Wrought Iron',3)
realtest.register_metal('nickel','Nickel',4)
realtest.register_metal('steel','Steel',4)
realtest.register_metal('tungsten','Tungsten',4)
realtest.register_metal('cobalt','Cobalt',5)
realtest.register_metal('black_steel','Black Steel',5)
realtest.register_metal('pobedit','Pobedit',6)

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
		{"default:clay_lump", "", "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump", "default:clay_lump"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "metals:ceramic_mold",
	recipe = "metals:clay_mold",
})

-- realtest.register_smelting('magnetite','Magnetite','pig_iron')
-- realtest.register_smelting('hematite','Hematite','pig_iron')
-- realtest.register_smelting('limonite','Limonite','pig_iron')
realtest.register_smelting('bismuthinite','Bismuthinite','bismuth')
realtest.register_smelting('cassiterite','Cassiterite','tin')
-- realtest.register_smelting('galena','Galena','lead')
realtest.register_smelting('malachite','Malachite','copper')
realtest.register_smelting('native_copper','Native Copper','copper')
-- realtest.register_smelting('native_gold','Native Gold','gold')
-- realtest.register_smelting('native_platinum','Native Platinum','platinum')
-- realtest.register_smelting('native_silver','Native Silver','silver')
realtest.register_smelting('sphalerite','Sphalerite','zinc')
realtest.register_smelting('tetrahedrite','Tetrahedrite','copper')
-- realtest.register_smelting('garnierite','Garnierite','nickel')
-- realtest.register_smelting('skutterudite','Skutterudite','cobalt')
-- realtest.register_smelting('cobaltite','Cobaltite','cobalt')
-- realtest.register_smelting('bauxite','Bauxite','aluminium')
-- realtest.register_smelting('scheelite','Scheelite','tungsten')
-- realtest.register_smelting('wolframite','Wolframite','tungsten')

--
-- Alloys
--

realtest.register_alloy("metals:steel_unshaped 4",
	{"metals:wrought_iron_unshaped", "metals:wrought_iron_unshaped", "metals:wrought_iron_unshaped", "metals:pig_iron_unshaped"})
realtest.register_alloy("metals:brass_unshaped 4",
	{"metals:copper_unshaped", "metals:copper_unshaped", "metals:copper_unshaped", "metals:zinc_unshaped"})
realtest.register_alloy("metals:sterling_silver_unshaped 4",
	{"metals:silver_unshaped", "metals:silver_unshaped", "metals:silver_unshaped", "metals:copper_unshaped"})
realtest.register_alloy("metals:rose_gold_unshaped 4",
	{"metals:gold_unshaped", "metals:gold_unshaped", "metals:gold_unshaped", "metals:brass_unshaped"})
realtest.register_alloy("metals:black_bronze_unshaped 4",
	{"metals:copper_unshaped", "metals:copper_unshaped", "metals:gold_unshaped", "metals:silver_unshaped"})
realtest.register_alloy("metals:bismuth_bronze_unshaped 4",
	{"metals:copper_unshaped", "metals:copper_unshaped", "metals:bismuth_unshaped", "metals:tin_unshaped"})
realtest.register_alloy("metals:bronze_unshaped 4",
	{"metals:copper_unshaped", "metals:copper_unshaped", "metals:copper_unshaped", "metals:tin_unshaped"})
realtest.register_alloy("metals:black_steel_unshaped 4",
	{"metals:steel_unshaped", "metals:steel_unshaped", "metals:nickel_unshaped", "metals:black_bronze_unshaped"})
realtest.register_alloy("metals:pobedit_unshaped 2",
	{"metals:cobalt_unshaped", "metals:tungsten_carbide_unshaped"})

--
-- Other
--

minetest.register_craftitem("metals:ceramic_mold_tungsten_unshaped_coke", {
	description = "Ceramic mold with unshaped tungsten and coke",
	inventory_image = "metals_ceramic_mold_tungsten_unshaped_coke.png",
})

minetest.register_craftitem("metals:tungsten_carbide_unshaped", {
	description = "Unshaped Tungsten Carbide",
	inventory_image = "metals_tungsten_carbide_unshaped.png",
})

minetest.register_craft({
	output = "metals:ceramic_mold_tungsten_unshaped_coke",
	recipe = {
		{"coke:coke"},
		{"metals:tungsten_unshaped"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "metals:tungsten_carbide_unshaped",
	recipe = "metals:ceramic_mold_tungsten_unshaped_coke",
})