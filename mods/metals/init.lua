metals = {}
metals.spear = {}

metals.spear.damage = 10
metals.spear.gravity = 9
metals.spear.velocity = 19

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

dofile(minetest.get_modpath("metals").."/groupcaps.lua")
dofile(minetest.get_modpath("metals").."/buckets.lua")

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
	
	minetest.register_craftitem("metals:tool_pick_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Pickaxe Head",
		inventory_image = "metals_tool_pick_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_axe_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Axe Head",
		inventory_image = "metals_tool_axe_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_shovel_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Shovel Head",
		inventory_image = "metals_tool_shovel_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_sword_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Sword Head",
		inventory_image = "metals_tool_sword_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_hammer_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Hammer Head",
		inventory_image = "metals_tool_hammer_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_spear_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Spear Head",
		inventory_image = "metals_tool_spear_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_chisel_"..metals.list[i].."_head", {
		description =metals.desc_list[i].." Chisel Head",
		inventory_image = "metals_tool_chisel_"..metals.list[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:ceramic_mold_"..metals.list[i], {
		description = "Ceramic Mold with "..metals.desc_list[i],
		inventory_image = "metals_ceramic_mold.png^metals_"..metals.list[i].."_ingot.png",
	})
	
	minetest.register_craftitem("metals:tool_spear_"..metals.list[i], {
		description = metals.desc_list[i].." spear",
		inventory_image = "metals_tool_spear_"..metals.list[i]..".png",
		on_use = function (item, player, pointed_thing)
			local playerpos=player:getpos()
			local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "metals:spear_entity")
			local dir=player:get_look_dir()
			obj:setvelocity({x=dir.x*metals.spear.velocity, y=dir.y*metals.spear.velocity, z=dir.z*metals.spear.velocity})
			obj:setacceleration({x=dir.x*-3, y=-metals.spear.gravity, z=dir.z*-3})
			return ""
		end,
		stack_max = 1,
	})
	
	minetest.register_tool("metals:tool_chisel_"..metals.list[i], {
		description = metals.desc_list[i].." chisel",
		inventory_image = "metals_tool_chisel_"..metals.list[i]..".png",
		on_use = function (item, player, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			if minetest.env:get_node(pointed_thing.under).name == "default:stone" then
				minetest.env:add_node(pointed_thing.under, {name="default:stone_flat"})
			end
			if minetest.env:get_node(pointed_thing.under).name == "default:desert_stone" then
				minetest.env:add_node(pointed_thing.under, {name="default:desert_stone_flat"})
			end
			item:add_wear(65535/10)
			return item
		end,
	})
	
	--
	-- Nodes
	--
	
	minetest.register_node("metals:"..metals.list[i].."_block", {
		description = "Block of "..metals.desc_list[i],
		tiles = {"metals_"..metals.list[i].."_block.png"},
		is_ground_content = true,
		groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2},
		sounds = default.node_sound_stone_defaults(),
	})
	
	--
	-- Tools
	--
	
	minetest.register_tool("metals:tool_pick_"..metals.list[i], {
		description = metals.desc_list[i].." Pickaxe",
		inventory_image = "metals_tool_pick_"..metals.list[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps={
				cracky=PICKS_CRACKY_LIST[i],
			}
		},
	})
	minetest.register_tool("metals:tool_shovel_"..metals.list[i], {
		description = metals.desc_list[i].." Shovel",
		inventory_image = "metals_tool_shovel_"..metals.list[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps={
				crumbly=SHOVELS_CRUMBLY_LIST[i],
			}
		},
	})
	minetest.register_tool("metals:tool_axe_"..metals.list[i], {
		description = metals.desc_list[i].." Axe",
		inventory_image = "metals_tool_axe_"..metals.list[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps=AXE_GROUPCAPS[i],
		},
	})
	minetest.register_tool("metals:tool_sword_"..metals.list[i], {
		description = metals.desc_list[i].." Sword",
		inventory_image = "metals_tool_sword_"..metals.list[i]..".png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps=SWORD_GROUPCAPS[i],
		}
	})
	
	--
	-- Crafts
	--
	
	minetest.register_craft({
		output = "metals:"..metals.list[i].."_block",
		recipe = {
			{"metals:"..metals.list[i].."_ingot", "metals:"..metals.list[i].."_ingot"},
			{"metals:"..metals.list[i].."_ingot", "metals:"..metals.list[i].."_ingot"},
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
	
	minetest.register_craft({
		output = 'sawing_table:self',
		recipe = {
			{'default:tree',"metals:"..metals.list[i].."_ingot",'default:tree'},
			{'default:tree','','default:tree'},
			{'default:tree',"metals:"..metals.list[i].."_ingot",'default:tree'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_pick_"..metals.list[i],
		recipe = {
			{"metals:tool_pick_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_axe_"..metals.list[i],
		recipe = {
			{"metals:tool_axe_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_shovel_"..metals.list[i],
		recipe = {
			{"metals:tool_shovel_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_sword_"..metals.list[i],
		recipe = {
			{"metals:tool_sword_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_hammer_"..metals.list[i],
		recipe = {
			{"metals:tool_hammer_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_spear_"..metals.list[i],
		recipe = {
			{"metals:tool_spear_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_chisel_"..metals.list[i],
		recipe = {
			{"metals:tool_chisel_"..metals.list[i].."_head"},
			{'default:stick'},
		}
	})
	
	--
	-- Coocking
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
-- Recipes
--

metals.recipes = {
	{"metals:recipe_pick", "Pick Recipe"},
	{"metals:recipe_axe", "Axe Recipe"},
	{"metals:recipe_shovel", "Shovel Recipe"},
	{"metals:recipe_sword", "Sword Recipe"},
	{"metals:recipe_hammer", "Hammer Recipe"},
	{"metals:recipe_spear", "Spear Recipe"},
	{"metals:recipe_bucket","Bucket Recipe"},
}

for _, recipe in ipairs(metals.recipes) do
	minetest.register_craftitem(recipe[1], {
		description = recipe[2],
		inventory_image = "metals_recipe.png",
		stack_max = 1,
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

--
-- Entitis

metals.spear.entity = {
	physical = false,
	timer=0,
	textures = {"spear_back.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}

metals.spear.entity.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	local node = minetest.env:get_node(pos)

	if self.timer>0.2 then
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
		for k, obj in pairs(objs) do
			obj:set_hp(obj:get_hp()-metals.spear.damage)
			if obj:get_entity_name() ~= "metals:spear_entity" then
				if obj:get_hp()<=0 then 
					obj:remove()
				end
				self.object:remove() 
			end
		end
	end

	if self.lastpos.x~=nil then
		if node.name ~= "air" then
			minetest.env:add_item(self.lastpos, 'metals:tool_spear_bismuth')--FIXME
			self.object:remove()
		end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}
end

minetest.register_entity("metals:spear_entity", metals.spear.entity)
