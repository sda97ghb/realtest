realtest.registered_ores = {}
realtest.registered_ores_list = {}
local d_seed = 0
function realtest.register_ore(name, OreDef)
	local ore = {
		name = name,
		description = OreDef.description or "Ore",
		mineral = OreDef.mineral or "minerals:"..name:remove_modname_prefix(),
		wherein = OreDef.wherein or {"default:stone"},
		chunks_per_volume = OreDef.chunks_per_volume or 1/3/3/3/2,
		chunk_size = OreDef.chunk_size or 3,
		ore_per_chunk = OreDef.ore_per_chunk or 10,
		height_min = OreDef.height_min or -30912,
		height_max = OreDef.height_max or 30912,
		noise_min = OreDef.noise_min or 0.6,
		noise_max = OreDef.noise_max or nil,
		generate = true,
		delta_seed = OreDef.delta_seed or d_seed
	}
	d_seed = d_seed + 1
	if OreDef.generate == false then
		ore.generate = false
	end
	ore.particle_image = OreDef.particle_image or ore.mineral:gsub(":","_")..".png"
	realtest.registered_ores[name] = ore
	table.insert(realtest.registered_ores_list, name)
	local name_ = name:gsub(":","_")
	for i, wherein in ipairs(ore.wherein) do
		local wherein_ = wherein:gsub(":","_")
		local wherein_textures = {}
		if minetest.registered_nodes[wherein].tiles or minetest.registered_nodes[wherein].tile_images then
			for _, texture in ipairs(minetest.registered_nodes[wherein].tiles) do
				table.insert(wherein_textures, texture.."^"..name_..".png")
			end
		else
			wherein_textures = {name_..".png"}
		end
		minetest.register_node(":"..name.."_in_"..wherein_, {
			description = ore.description .. " Ore",
			tiles = wherein_textures,
			particle_image = {ore.particle_image},
			groups = {cracky=3,drop_on_dig=1,ore=1,dropping_like_stone=1},
			drop = {
				max_items = 1,
				items = {
					{
						items = {ore.mineral.." 2"},
						rarity = 2
					},
					{
						items = {ore.mineral}
					}
				}
			},
			sounds = default.node_sound_stone_defaults()
		})
	end
end

ores.list = {
--	"lignite",
-- 	"anthracite",
-- 	"bituminous_coal",
	"magnetite",
	"hematite",
	"limonite",
	"bismuthinite",
	"cassiterite",
	"galena",
	"garnierite",
	"malachite",
-- 	"native_copper",
-- 	"native_gold",
	"native_silver",
	"native_platinum",
	"sphalerite",
	"tetrahedrite",
	"lazurite",
	"bauxite",
	"cinnabar",
	"cryolite",
-- 	"graphite",
	"gypsum",
	"jet",
	"kaolinite",
	"kimberlite",
	"olivine",
	"petrified_wood",
-- 	"pitchblende",
	"saltpeter",
	"satin_spar",
	"selenite",
	"serpentine",
	"sylvite",
	"tenorite",
}
ores.desc_list = {
-- 	"Lignite",
-- 	"Anthracite",
-- 	"Bituminous Coal",
	"Magnetite",
	"Hematite",
	"Limonite",
	"Bismuthinite",
	"Cassiterite",
	"Galena",
	"Garnierite",
	"Malachite",
-- 	"Native Copper",
-- 	"Native Gold",
	"Native Silver",
	"Native Platinum",
	"Sphalerite",
	"Tetrahedrite",
	"Lazurite",
	"Bauxite",
	'Cinnabar',
	'Cryolite',
-- 	'Graphite',
	'Gypsum',
	'Jet',
	'Kaolinite',
	'Kimberlite',
	'Olovine',
	'Petrified wood',
-- 	'Pitchblende',
	'Saltpeter',
	'Satin Spar',
	'Selenite',
	'Serpentine',
	'Sylvite',
	'Tenorite',
}

for _, ore in ipairs(ores.list) do
	realtest.register_ore("ores:"..ore, {description = ores.desc_list[_]}) 
end

realtest.register_ore("ores:native_copper", {
	description = "Native Copper",
	wherein = {"default:stone", "default:desert_stone"}
})

realtest.register_ore("ores:native_gold", {
	description = "Native Gold",
	wherein = {"default:stone", "default:desert_stone"}
})

realtest.register_ore("ores:lignite", {
	description = "Lignite",
	height_max = -500,
	height_min = -3000,
	ore_per_chunk = 15,
	chunks_per_volume = 1/3/3/3,
})

realtest.register_ore("ores:bituminous_coal", {
	description = "Bituminous Coal",
	height_max = -3000,
	height_min = -6000,
	ore_per_chunk = 15,
	chunks_per_volume = 1/3/3/3,
})

realtest.register_ore("ores:anthracite", {
	description = "Anthracite",
	height_max = -6000,
	height_min = -8000,
	ore_per_chunk = 15,
	chunks_per_volume = 1/3/3/3,
})

realtest.register_ore("ores:graphite", {
	description = "Graphite",
	height_max = -8000,
	ore_per_chunk = 15,
})

minetest.register_node("ores:sulfur", {
	description = "Sulfur Ore",
	drawtype = "signlike",
	tile_images = {"ores_sulfur.png"},
	particle_image = {"minerals_sulfur.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {cracky=3,drop_on_dig=1,dig_immediate=2,attached_node=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"minerals:sulfur 3"},
				rarity = 15,
			},
			{
				items = {"minerals:sulfur 2"},
			}
		}
	},
})

minetest.register_node("ores:peat", {
	description = "Peat",
	tile_images = {"ores_peat.png"},
	particle_image = {"ores_peat.png"},
	groups = {crumbly=3,drop_on_dig=1,falling_node=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "ores:peat",
	burntime = 15
})