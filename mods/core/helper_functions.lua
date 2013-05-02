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

function copy_table(t)
    local u = { }
    for k, v in pairs(t) do
        u[k] = v
    end
    return setmetatable(u, getmetatable(t))
end

function mod_pos(p, dx, dy, dz)
    return { x = p.x + dx, y = p.y + dy, z = p.z + dz }
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
	for i = 1,2 do
		local i = self:find(":")
		if i then
			self = self:sub(i+1)
		end
	end
	return self
end

function string:get_modname_prefix()
	local i = self:find(":")
	if i == 1 then
		self = self:sub(2, -1)
	end
	i = self:find(":")
	if i then
		return self:sub(1, i-1)
	end
	return self
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