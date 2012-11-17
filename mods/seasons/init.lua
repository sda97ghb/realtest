DAY_LENGTH_TIME = 36000

realtest.get_day = function()
	local f = io.open(minetest.get_worldpath()..'/seasons.season', "r")
	local s = 1
	if f ~= nil then
		s = f:read("*n")
		io.close(f)
	end
	return s
end
realtest.set_day = function(t)
	local f = io.open(minetest.get_worldpath()..'/seasons.season', "w")
	f:write(t)
	io.close(f)
end

realtest.get_season = function()
	local day = realtest.get_day()
	if day > 0 then if day < 91 then return "spring" end end
	if day > 90 then if day < 181 then return "summer" end end
	if day > 181 then if day < 241 then return "autumn" end end
	if day > 240 then if day < 361 then return "winter" end end
	return "error"
end

add_day = function()
	realtest.set_day(realtest.get_day()+1)
	minetest.after(DAY_LENGTH_TIME,add_day)
end

minetest.after(DAY_LENGTH_TIME,add_day)

minetest.register_chatcommand("calendar", {
	params = "<>",
	description = "get the calendar",
	privs = {server=true},
	func = function(name, param)
		minetest.chat_send_player(name, "Day: "..realtest.get_day())
		minetest.chat_send_player(name, "Season: "..realtest.get_season())
	end,
})

minetest.register_chatcommand("setday", {
	params = "<day>",
	description = "set the day",
	privs = {server=true},
	func = function(name, param)
		realtest.set_day(param)
		minetest.chat_send_player(name, "Day changed to "..param)
	end,
})