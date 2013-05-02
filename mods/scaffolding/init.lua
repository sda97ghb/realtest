-- Event handlers
local function scaffolding_update(pos)
    local node_name = minetest.env:get_node(pos).name
    if minetest.get_node_group(node_name, "scaffolding") ~= 1 then
        return
    end
    local material = realtest.registered_trees_list[minetest.get_node_group(node_name, "material")]:remove_modname_prefix()
    if minetest.get_node_group(minetest.env:get_node(mod_pos(pos, 0, 1, 0)).name, "scaffolding") == 1 then
        minetest.env:add_node(pos, {name = "scaffolding:scaffolding_sub_"..material})
    else
        minetest.env:add_node(pos, {name = "scaffolding:scaffolding_top_"..material})
    end
end

local function scaffolding_construct(pos)
    scaffolding_update(pos)
    scaffolding_update(mod_pos(pos, 0, -1, 0))
end

local function scaffolding_destruct(pos)
    return
    scaffolding_update(mod_pos(pos, 0, -1, 0))
end

-- Register scaffolding nodes and crafts
for i, tree_name in ipairs(realtest.registered_trees_list) do
    local tree = realtest.registered_trees[tree_name]

    local texture_plank = "trees_"..tree.name:remove_modname_prefix().."_planks.png"
    local texture_top = texture_plank.."^scaffolding_wooden_top.png"
    local texture_side = "scaffolding_wooden_side.png"
    local texture_bottom = texture_top.."^scaffolding_wooden_bottom.png"

    local scaffolding = {
        description = tree.description.." Scaffolding",
        drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {
                -- side crosses
                {-0.5, -0.5, -0.5, -0.45, 0.5, 0.5},
                {-0.5, -0.5, -0.5, 0.5, 0.5, -0.45},
                {0.45, -0.5, -0.5, 0.5, 0.5, 0.5},
                {-0.5, -0.5, 0.45, 0.5, 0.5, 0.5},
                -- top plank
                {-0.5, 0.4, -0.5, 0.5, 0.5, 0.5},
            },
        },
        tiles = {texture_top, texture_bottom, texture_side, texture_side, texture_side, texture_side},
        drop = "scaffolding:scaffolding_"..tree.name:remove_modname_prefix(),
        paramtype = "light",
        sunlight_propagates = false,
        groups = {dig_immediate=3, material=i, dropping_node = 1, scaffolding=1},
        sounds = default.node_sound_wood_defaults(),
        on_construct = scaffolding_construct,
        climbable = true,
	walkable = false,
	cause_drop = function(pos, node)
		local b_pos = {x=pos.x,y=pos.y-1,z=pos.z}
		local b_node = minetest.env:get_node(b_pos)
		if minetest.get_node_group(b_node.name, "scaffolding") ~= 1 and minetest.registered_nodes[b_node.name].walkable == false then
			return true
		end
	end
    }

    local scaffolding_top = copy_table(scaffolding)
    scaffolding_top.on_construct = nil
    scaffolding_top.after_destruct = scaffolding_destruct

    local scaffolding_sub = copy_table(scaffolding_top)
    scaffolding_sub.tiles = {texture_side, texture_side, texture_side, texture_side, texture_side, texture_side}
    scaffolding_sub.sunlight_propagates = true

    minetest.register_node("scaffolding:scaffolding_"..tree.name:remove_modname_prefix(), scaffolding)
    minetest.register_node("scaffolding:scaffolding_top_"..tree.name:remove_modname_prefix(), scaffolding_top)
    minetest.register_node("scaffolding:scaffolding_sub_"..tree.name:remove_modname_prefix(), scaffolding_sub)

    minetest.register_craft({
        output = "scaffolding:scaffolding_"..tree.name:remove_modname_prefix().." 3",
        recipe = {
            {tree.name.."_plank",tree.name.."_plank",tree.name.."_plank"},
            {"","group:stick",""},
            {"group:stick","","group:stick"}
        }
    })
end

