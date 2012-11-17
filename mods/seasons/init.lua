local DAY_LENGTH_TIME = 1200

realtest.get_day = function()
	local f = io.open(minetest.get_worldpath()..'/season', "r")
	if f then
		local n = f:read("*n")
		io.close(f)
	end
	return n or 1
end

realtest.set_day = function(n)
	local f = io.open(minetest.get_worldpath()..'/season', "w")
	f:write((n % 360).."\n")
	f:write(math.floor(n / 360))
	io.close(f)
end

realtest.get_day_and_year = function()
	local f = io.open(minetest.get_worldpath()..'/season', "r")
	local n = 1
	local y = 0 
	if f then
		n = f:read("*n")
		y = f:read("*n")
		io.close(f)
	end
	return y, n
end

realtest.get_year =  function()
	local f = io.open(minetest.get_worldpath()..'/season', "r")
	if f then
		f:read("*n")
		local y = f:read("*n")
		io.close(f)
	end
	return y or 0
end

realtest.set_year = function(y)
	local n = realtest.get_day()
	local f = io.open(minetest.get_worldpath()..'/season', "w")
	f:write(n.."\n")
	f:write(y)
	io.close(f)
end

realtest.get_season = function()
	local day = realtest.get_day()
	if day > 0 and day < 91 then return "spring" end
	if day > 90 and day < 181 then return "summer" end
	if day > 180 and day < 241 then return "autumn" end
	if day > 240 and  day < 361 then return "winter" end
end

local add_day = function()
	if realtest.get_day() + 1 >= 360 then
		realtest.set_year(realtest.get_year() + 1)
		realtest.set_day(1)
	else
		realtest.set_day(realtest.get_day() + 1)
	end
	minetest.after(DAY_LENGTH_TIME, add_day)
end

if minetest.setting_get("time_speed") ~= 0 then
	minetest.after(DAY_LENGTH_TIME, add_day)
end

minetest.register_chatcommand("calendar", {
	params = "",
	description = "get the calendar",
	privs = {server=true},
	func = function(name, param)
		minetest.chat_send_player(name, "Day: "..realtest.get_day())
		minetest.chat_send_player(name, "Season: "..realtest.get_season())
		minetest.chat_send_player(name, "Year: "..realtest.get_year())
	end,
})

minetest.register_chatcommand("setday", {
	params = "<day>",
	description = "set the day",
	privs = {server=true},
	func = function(name, param)
		realtest.set_day(param)
		minetest.chat_send_player(name, "Day was changed to "..param)
	end,
})

minetest.register_chatcommand("setyear", {
	params = "<year>",
	description = "set the year",
	privs = {server=true},
	func = function(name, param)
		realtest.set_year(param)
		minetest.chat_send_player(name, "Year was changed to "..param)
	end,
})
