table.contains = function(t, v)
	for _, i in ipairs(t) do
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
