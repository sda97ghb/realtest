function table:contains(v)
	for _, i in ipairs(self) do
		if i == v then
			return true
		end
	end
	return false
end

function table:get_index(value)
	for i, v in ipairs(self) do
		if v == value then
			return i
		end
	end
end

function hacky_swap_node(pos,name)
	local node = minetest.env:get_node(pos)
	local meta = minetest.env:get_meta(pos)
	local meta0 = meta:to_table()
	if node.name == name then
		return
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.env:set_node(pos,node)
	meta = minetest.env:get_meta(pos)
	meta:from_table(meta0)
end

function string:capitalize()
	return self:sub(1,1):upper()..self:sub(2):lower()
end

function string:remove_modname_prefix()
	local i = self:find(":")
	if i then
		return self:sub(i+1)
	end
	return nil
end

function string:get_modname_prefix()
	local i = self:find(":")
	if i then
		return self:sub(1, i-1)
	end
	return nil
end

function set_node_instead_air(pos, node)
	if minetest.env:get_node(pos).name == "air" then
		minetest.env:set_node(pos, node)
	end
end

function merge(lhs, rhs)
	local merged_table = {}
	for _, v in ipairs(lhs) do
		table.insert(merged_table, v)
	end
	for _, v in ipairs(rhs) do
		table.insert(merged_table, v)
	end
	return merged_table
end

function rshift(x, by)
  return math.floor(x / 2 ^ by)
end