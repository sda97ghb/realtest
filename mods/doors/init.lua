doors = {}

-- Registers a door
--  name: The name of the door
--  def: a table with the folowing fields:
--    description
--    inventory_image
--    groups
--    tiles_bottom: the tiles of the bottom part of the door {front, side}
--    tiles_top: the tiles of the bottom part of the door {front, side}
--    If the following fields are not defined the default values are used
--    node_box_bottom
--    node_box_top
--    selection_box_bottom
--    selection_box_top
--    only_placer_can_open: if true only the player who placed the door can
--                          open it
function doors:register_door(name, def)
	def.groups.not_in_creative_inventory = 1
	def.groups.door = 1
	
	local box = {{-0.5, -0.5, -0.5,   0.5, 0.5, -0.5+1.5/16}}
	
	if not def.node_box_bottom then
		def.node_box_bottom = box
	end
	if not def.node_box_top then
		def.node_box_top = box
	end
	if not def.selection_box_bottom then
		def.selection_box_bottom= box
	end
	if not def.selection_box_top then
		def.selection_box_top = box
	end
	
	minetest.register_craftitem(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		
		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then
				return itemstack
			end
			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			if
				not minetest.registered_nodes[minetest.env:get_node(pt).name].buildable_to or
				not minetest.registered_nodes[minetest.env:get_node(pt2).name].buildable_to or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end
			
			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			if p2 == 0 then
				pt3.x = pt3.x-1
			elseif p2 == 1 then
				pt3.z = pt3.z+1
			elseif p2 == 2 then
				pt3.x = pt3.x+1
			elseif p2 == 3 then
				pt3.z = pt3.z-1
			end
			if minetest.get_item_group(minetest.env:get_node(pt3).name, "door") ~= 1 then
				minetest.env:set_node(pt, {name=name.."_b_1", param2=p2})
				minetest.env:set_node(pt2, {name=name.."_t_1", param2=p2})
			else
				minetest.env:set_node(pt, {name=name.."_b_2", param2=p2})
				minetest.env:set_node(pt2, {name=name.."_t_2", param2=p2})
			end
			
			if def.only_placer_can_open then
				local pn = placer:get_player_name()
				local meta = minetest.env:get_meta(pt)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
				meta = minetest.env:get_meta(pt2)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
			end
			
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
	
	local tt = def.tiles_top
	local tb = def.tiles_bottom
	
	local function after_dig_node(pos, name)
		if minetest.env:get_node(pos).name == name then
			minetest.env:remove_node(pos)
		end
	end
	
	local function on_punch(pos, dir, check_name, replace, replace_dir, params)
		pos.y = pos.y+dir
		if not minetest.env:get_node(pos).name == check_name then
			return
		end
		local p2 = minetest.env:get_node(pos).param2
		p2 = params[p2+1]
		
		local meta = minetest.env:get_meta(pos):to_table()
		minetest.env:set_node(pos, {name=replace_dir, param2=p2})
		minetest.env:get_meta(pos):from_table(meta)
		
		pos.y = pos.y-dir
		meta = minetest.env:get_meta(pos):to_table()
		minetest.env:set_node(pos, {name=replace, param2=p2})
		minetest.env:get_meta(pos):from_table(meta)
	end
	
	local function check_player_priv(pos, player)
		if not def.only_placer_can_open then
			return true
		end
		local meta = minetest.env:get_meta(pos)
		local pn = player:get_player_name()
		return meta:get_string("doors_owner") == pn
	end
	
	minetest.register_node(name.."_b_1", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1], tb[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_bottom
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_bottom
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, name.."_t_1")
		end,
		
		on_punch = function(pos, node, puncher)
			if check_player_priv(pos, puncher) then
				on_punch(pos, 1, name.."_t_1", name.."_b_2", name.."_t_2", {1,2,3,0})
			end
		end,
		
		can_dig = check_player_priv,
	})
	
	minetest.register_node(name.."_t_1", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1], tt[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_top
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_top
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
			after_dig_node(pos, name.."_b_1")
		end,
		
		on_punch = function(pos, node, puncher)
			if check_player_priv(pos, puncher) then
				on_punch(pos, -1, name.."_b_1", name.."_t_2", name.."_b_2", {1,2,3,0})
			end
		end,
		
		can_dig = check_player_priv,
	})
	
	minetest.register_node(name.."_b_2", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1].."^[transformfx", tb[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_bottom
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_bottom
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, name.."_t_2")
		end,
		
		on_punch = function(pos, node, puncher)
			if check_player_priv(pos, puncher) then
				on_punch(pos, 1, name.."_t_2", name.."_b_1", name.."_t_1", {3,0,1,2})
			end
		end,
		
		can_dig = check_player_priv,
	})
	
	minetest.register_node(name.."_t_2", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1].."^[transformfx", tt[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_top
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_top
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
			after_dig_node(pos, name.."_b_2")
		end,
		
		on_punch = function(pos, node, puncher)
			if check_player_priv(pos, puncher) then
				on_punch(pos, -1, name.."_b_2", name.."_t_1", name.."_b_1", {3,0,1,2})
			end
		end,
		
		can_dig = check_player_priv,
	})
	
end

for i, tree_name in ipairs(realtest.registered_trees_list) do
	local tree = realtest.registered_trees[tree_name]
	doors:register_door("doors:door_"..tree_name:remove_modname_prefix(), {
		description = tree.description,
		inventory_image = tree.textures.door_inventory,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2},
		tiles_bottom = {tree.textures.door_bottom,tree.textures.door_bottom},
		tiles_top = {tree.textures.door_top,tree.textures.door_top},
	})
	minetest.register_craft({
		output = "doors:door_"..tree_name:remove_modname_prefix(),
		recipe = {
			{tree.name.."_plank",tree.name.."_plank"},
			{tree.name.."_plank",tree.name.."_plank"},
			{tree.name.."_plank",tree.name.."_plank"}
		}
	})
	minetest.register_craft({
		type = "fuel",
		recipe = "doors:door_"..tree_name:remove_modname_prefix(),
		burntime = 15,
	})
	realtest.add_bonfire_fuel("doors:door_"..tree_name:remove_modname_prefix())
end