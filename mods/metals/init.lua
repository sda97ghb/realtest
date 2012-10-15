--replacements = {{"metals:"..METALS_LIST[i].."_unshaped", "metals:ceramic_mold"}}

SPEAR_DAMAGE=10
SPEAR_GRAVITY=9
SPEAR_VELOCITY=19

METALS_LIST={
	'bismuth',
	'pig_iron',
	'wrought_iron',
	'steel',
	'gold',
	'nickel',
	'platinum',
	'tin',
	'silver',
	'lead',
	'copper',
	'zinc',
	'brass',
	'sterling_silver',
	'rose_gold',
	'black_bronze',
	'bismuth_bronze',
	'bronze',
	'black_steel',
	'aluminium',
}

DESC_LIST={
	'Bismuth',
	'Pig iron',
	'Wrought iron',
	'Steel',
	'Gold',
	'Nickel',
	'Platinum',
	'Tin',
	'Silver',
	'Lead',
	'Copper',
	'Zinc',
	'Brass',
	'Sterling silver',
	'Rose gold',
	'Black bronze',
	'Bismuth bronze',
	'Bronze',
	'Black steel',
	'Aluminium'
}

DESC_SMALL_LIST={
	'bismuth',
	'pig iron',
	'wrought iron',
	'steel',
	'gold',
	'nickel',
	'platinum',
	'tin',
	'silver',
	'lead',
	'copper',
	'zinc',
	'brass',
	'sterling silver',
	'rose gold',
	'black bronze',
	'bismuth bronze',
	'bronze',
	'black steel',
	'aluminium',
}


dofile(minetest.get_modpath("metals").."/groupcaps.lua")
dofile(minetest.get_modpath("metals").."/buckets.lua")

for i=1, #METALS_LIST do
	
	--
	-- Craftitems
	--
	
	minetest.register_craftitem("metals:"..METALS_LIST[i].."_unshaped", {
		description = "Unshaped "..DESC_SMALL_LIST[i],
		inventory_image = "metals_"..METALS_LIST[i].."_unshaped.png",
	})
	
	minetest.register_craftitem("metals:"..METALS_LIST[i].."_ingot", {
		description = DESC_LIST[i].." ingot",
		inventory_image = "metals_"..METALS_LIST[i].."_ingot.png",
	})
	
	minetest.register_craftitem("metals:tool_pick_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." pickaxe head",
		inventory_image = "metals_tool_pick_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_axe_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." axe head",
		inventory_image = "metals_tool_axe_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_shovel_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." shovel head",
		inventory_image = "metals_tool_shovel_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_sword_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." sword head",
		inventory_image = "metals_tool_sword_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_hammer_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." hammer head",
		inventory_image = "metals_tool_hammer_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_spear_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." spear head",
		inventory_image = "metals_tool_spear_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:tool_chisel_"..METALS_LIST[i].."_head", {
		description =DESC_LIST[i].." chisel head",
		inventory_image = "metals_tool_chisel_"..METALS_LIST[i].."_head.png",
	})
	
	minetest.register_craftitem("metals:ceramic_mold_"..METALS_LIST[i], {
		description = "Ceramic mold with "..DESC_SMALL_LIST[i],
		inventory_image = "metals_ceramic_mold.png^metals_"..METALS_LIST[i].."_ingot.png",
	})
	
	minetest.register_craftitem("metals:tool_spear_"..METALS_LIST[i], {
		description = DESC_LIST[i].." spear",
		inventory_image = "metals_tool_spear_"..METALS_LIST[i]..".png",
		on_use = function (item, player, pointed_thing)
			local playerpos=player:getpos()
			local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "metals:spear_entity")
			local dir=player:get_look_dir()
			obj:setvelocity({x=dir.x*SPEAR_VELOCITY, y=dir.y*SPEAR_VELOCITY, z=dir.z*SPEAR_VELOCITY})
			obj:setacceleration({x=dir.x*-3, y=-SPEAR_GRAVITY, z=dir.z*-3})
			return ""
		end,
		stack_max = 1,
	})
	
	minetest.register_craftitem("metals:tool_chisel_"..METALS_LIST[i], {
		description = DESC_LIST[i].." chisel",
		inventory_image = "metals_tool_chisel_"..METALS_LIST[i]..".png",
		on_use = function (item, player, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			if minetest.env:get_node(pointed_thing.under).name == "default:stone" then
				minetest.env:add_node(pointed_thing.under, {name="realistic_add_blocks:stone_flat"})
			end
			if minetest.env:get_node(pointed_thing.under).name == "default:desert_stone" then
				minetest.env:add_node(pointed_thing.under, {name="realistic_add_blocks:desert_stone_flat"})
			end
		end,
		stack_max = 1,
	})
	
	--
	-- Nodes
	--
	
	minetest.register_node("metals:"..METALS_LIST[i].."_block", {
		description = "Block of "..DESC_SMALL_LIST[i],
		tiles = {"metals_"..METALS_LIST[i].."_block.png"},
		is_ground_content = true,
		groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2},
		sounds = default.node_sound_stone_defaults(),
	})
	
	--
	-- Tools
	--
	
	minetest.register_tool("metals:tool_pick_"..METALS_LIST[i], {
		description = DESC_LIST[i].." pickaxe",
		inventory_image = "metals_tool_pick_"..METALS_LIST[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps={
				cracky=PICKS_CRACKY_LIST[i],
			}
		},
	})
	minetest.register_tool("metals:tool_shovel_"..METALS_LIST[i], {
		description = DESC_LIST[i].." shovel",
		inventory_image = "metals_tool_shovel_"..METALS_LIST[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps={
				crumbly=SHOVELS_CRUMBLY_LIST[i],
			}
		},
	})
	minetest.register_tool("metals:tool_axe_"..METALS_LIST[i], {
		description = DESC_LIST[i].." axe",
		inventory_image = "metals_tool_axe_"..METALS_LIST[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps=AXE_GROUPCAPS[i],
		},
	})
	minetest.register_tool("metals:tool_sword_"..METALS_LIST[i], {
		description = DESC_LIST[i].." sword",
		inventory_image = "metals_tool_sword_"..METALS_LIST[i]..".png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps=SWORD_GROUPCAPS[i],
		}
	})
	minetest.register_tool("metals:tool_hammer_"..METALS_LIST[i], {
		description = DESC_LIST[i].." hammer",
		inventory_image = "metals_tool_hammer_"..METALS_LIST[i]..".png",
		tool_capabilities = {
			max_drop_level=1,
			groupcaps={
				cracky=PICKS_CRACKY_LIST[i],
			}
		},
	})
	
	--
	-- Crafts
	--
	
	minetest.register_craft({
		output = "metals:"..METALS_LIST[i].."_block",
		recipe = {
			{"metals:"..METALS_LIST[i].."_ingot", "metals:"..METALS_LIST[i].."_ingot"},
			{"metals:"..METALS_LIST[i].."_ingot", "metals:"..METALS_LIST[i].."_ingot"},
		}
	})
	
	minetest.register_craft({
		output = "metals:"..METALS_LIST[i].."_ingot 4",
		recipe = {
			{"metals:"..METALS_LIST[i].."_block"},
		}
	})
	
	minetest.register_craft({
		output = "metals:ceramic_mold_"..METALS_LIST[i],
		recipe = {
			{"metals:"..METALS_LIST[i].."_ingot"},
			{"metals:ceramic_mold"},
		}
	})
	
	minetest.register_craft({
		output = "metals:"..METALS_LIST[i].."_ingot",
		recipe = {
			{"metals:"..METALS_LIST[i].."_unshaped"},
		},
	})
	
	minetest.register_craft({
		output = 'sawing_table:self',
		recipe = {
			{'default:tree',"metals:"..METALS_LIST[i].."_ingot",'default:tree'},
			{'default:tree','','default:tree'},
			{'default:tree',"metals:"..METALS_LIST[i].."_ingot",'default:tree'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_pick_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_pick_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_axe_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_axe_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_shovel_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_shovel_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_sword_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_sword_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_hammer_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_hammer_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_spear_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_spear_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	minetest.register_craft({
		output = "metals:tool_chisel_"..METALS_LIST[i],
		recipe = {
			{"metals:tool_chisel_"..METALS_LIST[i].."_head"},
			{'default:stick'},
		}
	})
	
	--
	-- Coocking
	--
	
	minetest.register_craft({
		type = "cooking",
		output = "metals:"..METALS_LIST[i].."_unshaped",
		recipe = "metals:ceramic_mold_"..METALS_LIST[i],
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

minetest.register_craftitem("metals:recipe_pick", {
	description = "Pick recipe",
	inventory_image = "metals_recipe.png",
})

minetest.register_craftitem("metals:recipe_axe", {
	description = "Axe recipe",
	inventory_image = "metals_recipe.png",
})

minetest.register_craftitem("metals:recipe_shovel", {
	description = "Shovel recipe",
	inventory_image = "metals_recipe.png",
})

minetest.register_craftitem("metals:recipe_sword", {
	description = "Sword recipe",
	inventory_image = "metals_recipe.png",
})

minetest.register_craftitem("metals:recipe_hammer", {
	description = "Hammer recipe",
	inventory_image = "metals_recipe.png",
})

minetest.register_craftitem("metals:recipe_spear", {
	description = "Spear recipe",
	inventory_image = "metals_recipe.png",
})

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

minetest.register_craftitem(":default:steel_ingot", {
	description = "Double wrought ingot",
	inventory_image = "metals_wrought_iron_ingot.png",
})

--
-- Entitis

SPEAR_ENTITY={
	physical = false,
	timer=0,
	textures = {"spear_back.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}

SPEAR_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	local node = minetest.env:get_node(pos)

	if self.timer>0.2 then
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
		for k, obj in pairs(objs) do
			obj:set_hp(obj:get_hp()-SPEAR_DAMAGE)
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
			minetest.env:add_item(self.lastpos, 'metals:tool_spear_bismuth')
			self.object:remove()
		end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}
end

minetest.register_entity("metals:spear_entity", SPEAR_ENTITY)
