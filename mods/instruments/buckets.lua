buckets = {}
buckets.liquids = {}
buckets.replacements = {}

local function wood_name(o)
	return o.name:remove_modname_prefix()
end

local function wood_desc(o)
	return o.description
end

local function wood_image()
	return "instruments_bucket_wood.png"
end

local function wood_craft(tree)
	minetest.register_craft({
		output = "instruments:bucket_"..wood_name(tree),
		recipe = {
			{tree.name.."_plank", "", tree.name.."_plank"},
			{tree.name.."_plank", "", tree.name.."_plank"},
			{"", tree.name.."_plank", ""},
		},
	})
end

buckets.types = {
	{name = "metal", list = metals.list, desc_list = metals.desc_list},
	{name = "wood", list = realtest.registered_trees, name_func = wood_name, desc_func = wood_desc, image_func = wood_image, craft_func = wood_craft}
}

realtest.registered_liquids = {}

local function bucket_name(material, liquid)
	local s = "instruments:bucket_"..material
	if liquid ~= nil then
		s = s.."_with_"..liquid
	end
	return s
end

local function add_replacement(full, empty, liquid)
	if buckets.replacements[liquid] == nil then
		buckets.replacements[liquid] = {}
	end
	table.insert(buckets.replacements[liquid], {full, empty})
end

local function get_bucket_info(type, material, i)
	local name = ""
	if type.name_func then
		name = type.name_func(material, i)
	else
		name = tostring(material)
	end

	local description = ""
	if type.desc_func then
		description = type.desc_func(material, i)
	elseif type.desc_list then
		description = type.desc_list[i]
	end

	local image = "instruments_bucket_"..name..".png"
	if type.image_func then
		image = type.image_func(material, i)
	end

	return name, description, image
end

function realtest.register_liquid(name, LiquidDef)
	if name and LiquidDef.source and LiquidDef.flowing then
		LiquidDef.name = name
		realtest.registered_liquids[LiquidDef.source] = LiquidDef
		realtest.registered_liquids[LiquidDef.flowing] = LiquidDef
	end

	for _, type in ipairs(buckets.types) do
		if LiquidDef["image_for_"..type.name.."_bucket"] then
			for i, material in pairs(type.list) do
				local name, description, image = get_bucket_info(type, material, i)

				local full_name = bucket_name(name, LiquidDef.name)
				local empty_name = bucket_name(name)
				local groups = {["bucket_with_"..LiquidDef.name]=1}
				if LiquidDef.bucket_groups then
					setmetatable(groups, {__index = LiquidDef.bucket_groups})
				end
				local stack = 1
				if LiquidDef.bucket_stack then
					stack = LiquidDef.bucket_stack
				end

				add_replacement(full_name, empty_name, LiquidDef.name)

				minetest.register_craftitem(":"..full_name, {
					description = description .. " Bucket with " .. LiquidDef.description,
					inventory_image = image.."^"..LiquidDef["image_for_"..type.name.."_bucket"],
					groups = groups,
					stack_max = stack,
					liquids_pointable = true,
					on_use = function(itemstack, user, pointed_thing)
						-- "virtual" buckets
						if LiquidDef.source == "" then
							return
						end
						-- Must be pointing to node
						if pointed_thing.type ~= "node" then
							return
						end
						n = minetest.env:get_node(pointed_thing.under)
						if minetest.registered_nodes[n.name].buildable_to then
							minetest.env:add_node(pointed_thing.under, {name=LiquidDef.source})
						else
							n = minetest.env:get_node(pointed_thing.above)
							if minetest.registered_nodes[n.name].buildable_to then
								minetest.env:add_node(pointed_thing.above, {name=LiquidDef.source})
							else
								return
							end
						end
						return {name=empty_name}
					end
				})
			end
		end
	end
end

for _, type in ipairs(buckets.types) do
	for i, material in pairs(type.list) do
		local name, description, image = get_bucket_info(type, material, i)
		local empty_name = bucket_name(name)
		table.insert(buckets, empty_name)

		minetest.register_craftitem(":"..bucket_name(name), {
			description = "Empty " .. description .. " Bucket",
			inventory_image = image,
			groups = {bucket_empty = 1},
			stack_max = 1,
			liquids_pointable = true,
			on_use = function(itemstack, user, pointed_thing)
				if pointed_thing.type ~= "node" then
					return
				end
				local n = minetest.env:get_node(pointed_thing.under)
				local liquiddef = realtest.registered_liquids[n.name]
				if not liquiddef then
					return
				end
				local full_name = empty_name.."_with_"..liquiddef.name
				if liquiddef and n.name == liquiddef.source and minetest.registered_items[full_name] then
					minetest.env:add_node(pointed_thing.under, {name="air"})
					return {name=full_name}
				end
			end,
		})

		if type.craft_func then
			type.craft_func(material, i)
		end
	end
end

realtest.register_liquid("water", {
	description = "Water",
	source = "default:water_source",
	flowing = "default:water_flowing",
	image_for_metal_bucket = "instruments_metal_water.png",
	image_for_wood_bucket = "instruments_wood_water.png",
})

realtest.register_liquid("lava", {
	description = "Lava",
	source = "default:lava_source",
	flowing = "default:lava_flowing",
	image_for_metal_bucket = "instruments_lava.png",
})
