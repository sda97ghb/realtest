seasons = {}

seasons.months = {
	"Unuber",
	"Duober",
	"Treber",
	"Quattuorber",
	"Quinber",
	"Sexber",
	"September",
	"October",
	"November",
	"December",
	"Undecimber",
	"Duodecimber",
	"Tredecimber"
}

realtest.get_day = function()
	local f = io.open(minetest.get_worldpath()..'/season', "r")
	local n
	if f then
		n = f:read("*n")
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
	local y
	if f then
		f:read("*n")
		y = f:read("*n")
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

realtest.leap_year = function()
	return realtest.get_year() % 62 > 51
end

realtest.get_season = function()
	local day = realtest.get_day()
	if day > 0 and day <= 91 then return "Spring" end
	if day > 91 and day <= 182 then return "Summer" end
	if day > 181 and day <= 273 then return "Autumn" end
	if realtest.leap_year then
		if day > 272 and  day <= 371 then return "Winter" end
	else
		if day > 272 and  day <= 364 then return "Winter" end
	end
end

realtest.get_month = function()
	local n = math.floor(realtest.get_day() / 28)
	if n < 13 then n = n + 1 end
	return seasons.months[n], n
end

realtest.get_day_of_month = function()
	local n = math.floor(realtest.get_day() / 28)
	local n2 = realtest.get_day() % 28
	if n == 13 then n2 = n2 + 28 end
	return n2
end

add_day = function()
	local f
	if realtest.leap_year() then
		f = 371
	else
		f = 364
	end
	if realtest.get_day() + 1 > f then
		realtest.set_year(realtest.get_year() + 1)
		realtest.set_day(1)
	else
		realtest.set_day(realtest.get_day() + 1)
	end
	minetest.after(math.floor(86400 / minetest.setting_get("time_speed")), add_day)
end

if minetest.setting_get("time_speed") ~= 0 then
	minetest.after(math.floor(86400 / minetest.setting_get("time_speed")), add_day)
end

minetest.register_chatcommand("calendar", {
	params = "",
	description = "get the calendar",
	privs = {server=true},
	func = function(name, param)
		minetest.chat_send_player(name, "Date: "..realtest.get_month().." "..realtest.get_day_of_month()..", "..realtest.get_year())
		minetest.chat_send_player(name, "Season: "..realtest.get_season())
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
