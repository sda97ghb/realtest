-- Unified Dyes Mod by Vanessa Ezekowitz  ~~  2012-07-24
--
-- License: GPL
--
-- This mod depends on ironzorg's flowers mod and my Vessels mod.

--============================================================================
-- First, craft some bottles from the Vessels mod, then make some dye base:
-- Craft six empty bottles along with a bucket of water and a piece
-- of jungle grass to get 6 portions of dye base.

-- These craft/craftitem definitions for glass bottles are deprecated and are
-- only included here for backwards compatibility. Use vessels:glass_bottle
-- instead.
--

-- hacky way to make sure all buckets are correctly used
paints = {"white", "lightgrey", "grey", "darkgrey"}
for _, paint in ipairs(paints) do
        realtest.register_liquid(paint, {
                description = paint:gsub("^%l", string.upper).." Paint",
                source = "",
                flowing = "",
                image_for_metal_bucket = "unifieddyes_metal_"..paint..".png",
                image_for_wood_bucket = "unifieddyes_wood_"..paint..".png",
                bucket_groups = {dye = 1, ["unicolor_"..paint] = 1},
                bucket_stack = 99
        })
        for _, bucket in ipairs(buckets) do
                -- White paint

                minetest.register_craft( {
                        type = "shapeless",
                        output = bucket.."_with_white",
                        recipe = {
                                "unifieddyes:titanium_dioxide",
                                bucket.."_with_water",
                        },
                })

                -- Light grey paint

                minetest.register_craft( {
                       type = "shapeless",
                       output = bucket.."_with_lightgrey 3",
                       recipe = {
                               bucket.."_with_white",
                               bucket.."_with_white",
                               "unifieddyes:carbon_black",
                                },
                })

                -- Medium grey paint

                minetest.register_craft( {
                       type = "shapeless",
                       output = bucket.."_with_grey 2",
                       recipe = {
                               bucket.."_with_white",
                               "unifieddyes:carbon_black",
                                },
                })

                -- Dark grey paint

                minetest.register_craft( {
                       type = "shapeless",
                       output = bucket.."_with_darkgrey 3",
                       recipe = {
                               bucket.."_with_white",
                               "unifieddyes:carbon_black",
                               "unifieddyes:carbon_black",
                                },
                })
        end
end

minetest.register_craftitem("unifieddyes:empty_bottle", {
        description = "Glass Bottle (empty) (Deprecated)",
        inventory_image = "unifieddyes_empty_bottle.png",
})

minetest.register_craft( {
        type = "shapeless",
        output = "vessels:glass_fragments",
        recipe = {
                "unifieddyes:empty_bottle",
                "unifieddyes:empty_bottle",
        },
})

-- Now the current stuff, using vessels:glass_bottle.

minetest.register_craftitem("unifieddyes:dye_base", {
        description = "Uncolored Dye Base Liquid",
        inventory_image = "unifieddyes_dye_base.png",
})

minetest.register_craft( {
	type = "shapeless",
	output = "unifieddyes:dye_base 6",
	recipe = {
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"group:bucket_with_water",
	},
	replacements = buckets.replacements.water,
})

--==========================================================================
-- Now we need to turn our color sources (flowers, etc) into pigments and from
-- there into actual usable dyes.  There are seven base colors - one for each
-- flower, plus black (as "carbon black") from coal, and white (as "titanium
-- dioxide") from stone.  Most give two portions of pigment; cactus gives 6,
-- stone gives 10.

pigments = {
	"red",
	"orange",
	"yellow",
	"green"
}

dyesdesc = {
	"Red",
	"Orange",
	"Yellow",
	"Green"
}
	
colorsources = {
	"flowers:flower_rose",
	"flowers:flower_tulip",
	"flowers:flower_dandelion_yellow",
	"flowers:flower_waterlily",
}

for color in ipairs(colorsources) do

	-- the recipes to turn sources into pigments

	minetest.register_craftitem("unifieddyes:pigment_"..pigments[color], {
		description = dyesdesc[color].." Pigment",
		inventory_image = "unifieddyes_pigment_"..pigments[color]..".png",
	})

	-- The recipes to turn pigments into usable dyes

	minetest.register_craftitem("unifieddyes:"..pigments[color], {
		description = "Full "..dyesdesc[color].." Dye",
		inventory_image = "unifieddyes_"..pigments[color]..".png",
		groups = { dye=1, ["basecolor_"..pigments[color]]=1, ["excolor_"..pigments[color]]=1, ["unicolor_"..pigments[color]]=1 }
	})

	minetest.register_craft( {
		type = "shapeless",
		output = "unifieddyes:"..pigments[color],
		recipe = {
			"unifieddyes:pigment_"..pigments[color],
			"unifieddyes:dye_base"
		}
	})
end

realtest.register_anvil_recipe({
	item1 = "minerals:hematite",
	output = "unifieddyes:pigment_red 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:cinnabar",
	output = "unifieddyes:pigment_red 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:tenorite",
	output = "unifieddyes:pigment_red 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:olivine",
	output = "unifieddyes:pigment_green 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:malachite",
	output = "unifieddyes:pigment_green 2"
})

minetest.register_craftitem("unifieddyes:pigment_white", {
	description = "White Pigment",
	inventory_image = "unifieddyes_pigment_white.png",
})

realtest.register_anvil_recipe({
	item1 = "minerals:kaolinite",
	output = "unifieddyes:pigment_white 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:sphalerite",
	output = "unifieddyes:pigment_white 2"
})

minetest.register_alias("unifieddyes:titanium_dioxide", "unifieddyes:pigment_white")

minetest.register_craft({
	type = "cooking",
	output = "unifieddyes:pigment_green 6",
	recipe = "default:cactus",
})

minetest.register_craftitem("unifieddyes:carbon_black", {
	description = "Carbon Black",
	inventory_image = "unifieddyes_carbon_black.png",
})

realtest.register_anvil_recipe({
	item1 = "default:coal_lump",
	output = "unifieddyes:carbon_black 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:lignite",
	output = "unifieddyes:carbon_black 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:bituminous_coal",
	output = "unifieddyes:carbon_black 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:anthracite",
	output = "unifieddyes:carbon_black 2"
})

realtest.register_anvil_recipe({
	item1 = "minerals:graphite",
	output = "unifieddyes:carbon_black 2"
})

minetest.register_craftitem("unifieddyes:black", {
	description = "Black Dye",
	inventory_image = "unifieddyes_black.png",
	groups = { dye=1, basecolor_black=1, excolor_black=1, unicolor_black=1 }
})

minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:black",
        recipe = {
                "unifieddyes:carbon_black",
                "unifieddyes:dye_base",
        },
})

--=======================================================================
-- Now that we have the dyes in a usable form, let's mix the various
-- ingredients together to create the rest of the mod's colors and greys.


----------------------------
-- The 5 levels of greyscale

-- see TOP

--=============================================================================
-- Smelting/crafting recipes needed to generate various remaining 'full' colors
-- (the register_craftitem functions are in the generate-the-rest loop below).

-- Cyan

minetest.register_craftitem("unifieddyes:cyan", {
        description = "Full Cyan Dye",
        inventory_image = "unifieddyes_cyan.png",
	groups = { dye=1, basecolor_cyan=1, excolor_cyan=1, unicolor_cyan=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:cyan 2",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:green",
		},
})

-- Magenta

minetest.register_craftitem("unifieddyes:magenta", {
        description = "Full Magenta Dye",
        inventory_image = "unifieddyes_magenta.png",
	groups = { dye=1, basecolor_magenta=1, excolor_magenta=1, unicolor_magenta=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:magenta 2",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:red",
		},
})

-- Lime

minetest.register_craftitem("unifieddyes:lime", {
        description = "Full Lime Dye",
        inventory_image = "unifieddyes_lime.png",
	groups = { dye=1, excolor_lime=1, unicolor_lime=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:lime 2",
       recipe = {
               "unifieddyes:yellow",
               "unifieddyes:green",
		},
})

-- Aqua

minetest.register_craftitem("unifieddyes:aqua", {
        description = "Full Aqua Dye",
        inventory_image = "unifieddyes_aqua.png",
	groups = { dye=1, excolor_aqua=1, unicolor_aqua=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:aqua 2",
       recipe = {
               "unifieddyes:cyan",
               "unifieddyes:green",
		},
})

-- Sky blue

minetest.register_craftitem("unifieddyes:skyblue", {
        description = "Full Sky-blue Dye",
        inventory_image = "unifieddyes_skyblue.png",
	groups = { dye=1, excolor_sky_blue=1, unicolor_sky_blue=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:skyblue 2",
       recipe = {
               "unifieddyes:cyan",
               "unifieddyes:blue",
		},
})

-- Red-violet

minetest.register_craftitem("unifieddyes:redviolet", {
        description = "Full Red-violet Dye",
        inventory_image = "unifieddyes_redviolet.png",
	groups = { dye=1, excolor_red_violet=1, unicolor_red_violet=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:redviolet 2",
       recipe = {
               "unifieddyes:red",
               "unifieddyes:magenta",
		},
})

-- We need to check if the version of the Flowers mod that is installed
-- contains geraniums or not.  If it doesn't, use the Viola to make blue dye.
-- If Geraniums do exist, use them to make blue dye instead, and use Violas
-- to get violet dye.  Violet can always be made by mixing blue with magenta
-- or red as usual.


minetest.register_craftitem("unifieddyes:pigment_blue", {
	description = "Blue Pigment",
	inventory_image = "unifieddyes_pigment_blue.png",
})

minetest.register_craft( {
	type = "shapeless",
	output = "unifieddyes:blue",
	recipe = {
		"unifieddyes:pigment_blue",
		"unifieddyes:dye_base"
	}
})

realtest.register_anvil_recipe({
	item1 = "minerals:lapis",
	output = "unifieddyes:pigment_blue 2"
})

minetest.register_craftitem("unifieddyes:blue", {
	description = "Full Blue Dye",
	inventory_image = "unifieddyes_blue.png",
	groups = { dye=1, basecolor_blue=1, excolor_blue=1, unicolor_blue=1 }
})

minetest.register_craftitem("unifieddyes:violet", {
        description = "Full Violet/Purple Dye",
        inventory_image = "unifieddyes_violet.png",
	groups = { dye=1, basecolor_violet=1, excolor_violet=1, unicolor_violet=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:violet 2",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:magenta",
		},
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:violet 3",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:blue",
               "unifieddyes:red",
		},
})
	       
minetest.register_craftitem("unifieddyes:pigment_violet", {
	description = "Violet Pigment",
	inventory_image = "unifieddyes_pigment_violet.png",
})

minetest.register_craft( {
	type = "shapeless",
	output = "unifieddyes:violet",
	recipe = {
		"unifieddyes:pigment_violet",
		"unifieddyes:dye_base"
	}
})

minetest.register_craft({
	recipe = {{"flowers:grass"}},
	output = "unifieddyes:pigment_green"
})

-- =================================================================

-- Finally, generate all of additional variants of hue, saturation, and
-- brightness.

-- "s50" in a file/item name means "saturation: 50%".
-- Brightness levels in the textures are 33% ("dark"), 66% ("medium"),
-- 100% ("full" but not so-named), and 150% ("light").

HUES = {
	"red",
	"orange",
	"yellow",
	"lime",
	"green",
	"aqua",
	"cyan",
	"skyblue",
	"blue",
	"violet",
	"magenta",
	"redviolet"
}

HUES2 = {
	"Red",
	"Orange",
	"Yellow",
	"Lime",
	"Green",
	"Aqua",
	"Cyan",
	"Sky-blue",
	"Blue",
	"Violet",
	"Magenta",
	"Red-violet"
}


for i = 1, 12 do

	hue = HUES[i]
	hue2 = HUES2[i]

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:dark_" .. hue .. "_s50",
        recipe = {
                "unifieddyes:" .. hue,
                "group:bucket_with_darkgrey",
	        },
        replacements = buckets.replacements.darkgrey
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:dark_" .. hue .. "_s50 3",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:black",
                "unifieddyes:black",
		"group:bucket_with_white"
	        },
        replacements = buckets.replacements.white
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:dark_" .. hue .. " 3",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:black",
                "unifieddyes:black",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:medium_" .. hue .. "_s50 1",
        recipe = {
                "unifieddyes:" .. hue,
                "group:bucket_with_grey",
	        },
        replacements = buckets.replacements.grey
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:medium_" .. hue .. "_s50 2",
        recipe = {
                "unifieddyes:" .. hue,
		"unifieddyes:black",
                "group:bucket_with_white",
	        },
        replacements = buckets.replacements.white
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:medium_" .. hue .. " 2",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:black",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:" .. hue .. "_s50 1",
        recipe = {
                "unifieddyes:" .. hue,
                "group:bucket_with_lightgrey",
	        },
        replacements = buckets.replacements.lightgrey
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:" .. hue .. "_s50 2",
        recipe = {
                "unifieddyes:" .. hue,
                "group:bucket_with_white",
                "group:bucket_with_white",
                "unifieddyes:black",
	        },
        replacements = buckets.replacements.white
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:light_" .. hue .. " 1",
        recipe = {
                "unifieddyes:" .. hue,
                "group:bucket_with_white",
	        },
        replacements = buckets.replacements.white
	})

	minetest.register_craftitem("unifieddyes:dark_" .. hue .. "_s50", {
		description = "Dark " .. hue2 .. " Dye (low saturation)",
		inventory_image = "unifieddyes_dark_" .. hue .. "_s50.png",
		groups = { dye=1, ["unicolor_dark_"..hue.."_s50"]=1 }
	})

	minetest.register_craftitem("unifieddyes:dark_" .. hue, {
		description = "Dark " .. hue2 .. " Dye",
		inventory_image = "unifieddyes_dark_" .. hue .. ".png",
		groups = { dye=1, ["unicolor_dark_"..hue]=1 }
	})

	minetest.register_craftitem("unifieddyes:medium_" .. hue .. "_s50", {
		description = "Medium " .. hue2 .. " Dye (low saturation)",
		inventory_image = "unifieddyes_medium_" .. hue .. "_s50.png",
		groups = { dye=1, ["unicolor_medium_"..hue.."_s50"]=1 }
	})

	minetest.register_craftitem("unifieddyes:medium_" .. hue, {
		description = "Medium " .. hue2 .. " Dye",
		inventory_image = "unifieddyes_medium_" .. hue .. ".png",
		groups = { dye=1, ["unicolor_medium_"..hue]=1 }
	})

	minetest.register_craftitem("unifieddyes:" .. hue .. "_s50", {
		description = "Full " .. hue2 .. " Dye (low saturation)",
		inventory_image = "unifieddyes_" .. hue .. "_s50.png",
		groups = { dye=1, ["unicolor_"..hue.."_s50"]=1 }
	})

	minetest.register_craftitem("unifieddyes:light_" .. hue, {
		description = "Light " .. hue2 .. " Dye",
		inventory_image = "unifieddyes_light_" .. hue .. ".png",
		groups = { dye=1, ["unicolor_light_"..hue]=1 }
	})

end

print("[UnifiedDyes] Loaded!")

