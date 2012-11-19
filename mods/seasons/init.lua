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

seasons.week = {
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday",
}

seasons.seasons = {
	"Spring",
	"Summer",
	"Autumn",
	"Winter"
}

seasons.day = 1
seasons.year = 0
seasons.timer = 0

local F = io.open(minetest.get_worldpath()..'/season', "r")
local d, y
if F then
	d = F:read("*n")
	y = F:read("*n")
	io.close(F)
end
seasons.day = d or seasons.day
seasons.year = y or seasons.year

local function sync()
	local F = io.open(minetest.get_worldpath()..'/season', "w")
	if F then
		F:write(seasons.day.."\n")
		F:write(seasons.year)
		io.close(F)
	end
	if not F then
		minetest.log("error", "Can't access the \""..minetest.get_worldpath().."/season".."\" file.")
	end
end

function seasons.get_day()
	return seasons.day
end

function seasons.get_year()
	return seasons.year
end

function seasons.leap_year()
	return seasons.year % 62 > 51
end

function seasons.get_current_year_length()
	if seasons.leap_year() then
		return 371
	else
		return 364
	end
end

function seasons.set_day(day)
	local year = 0
	while true do
		if year % 62 > 51 then
			if day > 371 then
				day = day - 371
				year = year + 1
			else break end
		else
			if day > 364 then
				day = day - 364
				year = year + 1
			else break end
		end
	end
	seasons.day = day
	seasons.year = year
	sync()
end

function seasons.set_year(year)
	seasons.year = year
	sync()
end

function seasons.get_day_of_month()
	local m = math.floor(seasons.day / 28)
	local d = seasons.day % 28
	if m == 13 then d = d + 28 end
	return d
end

function seasons.get_month()
	local m = math.floor(seasons.day / 28) + 1
	return seasons.months[m]
end

function seasons.get_day_of_week()
	local w = seasons.day % 7
	return seasons.week[w]
end

function seasons.get_season()
	local d = seasons.day
	if d >=   1 and d <=  91 then return seasons.seasons[1] end
	if d >=  92 and d <= 182 then return seasons.seasons[2] end
	if d >= 183 and d <= 273 then return seasons.seasons[3] end
	if d >= 274 and d <= 371 then return seasons.seasons[4] end
end

local function add_day()
	if seasons.day + 1 > seasons.get_current_year_length() then
		seasons.year = seasons.year + 1
		seasons.day = 1
	else
		seasons.day = seasons.day + 1
	end
	sync()
end

minetest.after(0, function()
	seasons.timer = math.floor(minetest.env:get_timeofday() * 1200)
	local delta = 0
	minetest.register_globalstep(function(dtime)
		delta = delta + dtime
		local q = 72/minetest.setting_get("time_speed")
		while delta >= q do
		    delta = delta - q
		    seasons.timer = seasons.timer + 1
		    if seasons.timer == 1200 then
		    	seasons.timer = 0
		    	add_day()
		    end
		end
	end)
end)

minetest.register_chatcommand("time", {
	params = "<0...24000>",
	description = "set time of day",
	privs = {settime=true},
	func = function(name, param)
		if param == "" then
			minetest.chat_send_player(name, "Missing parameter")
			return
		end
		local newtime = tonumber(param)
		if newtime == nil then
			minetest.chat_send_player(name, "Invalid time")
		else
			minetest.env:set_timeofday((newtime % 24000) / 24000)
			seasons.timer = (newtime % 24000) / 20
			minetest.chat_send_player(name, "Time of day changed.")
			minetest.log("action", name .. " sets time " .. newtime)
		end
	end,
})

minetest.register_chatcommand("calendar", {
	params = "",
	description = "get the calendar",
	privs = {server=true},
	func = function(name, param)
		minetest.chat_send_player(name, "Date: "..seasons.get_day_of_week().." "..seasons.get_day_of_month().." "..seasons.get_month().." "..seasons.get_year())
		local h = math.floor(minetest.env:get_timeofday() * 24)
		local m = math.floor((minetest.env:get_timeofday() * 24000 - h * 1000) * 0.06)
		if m < 10 then
			m = "0"..m
		end
		minetest.chat_send_player(name, "Time: "..h..":"..m)
		minetest.chat_send_player(name, "Season: "..seasons.get_season())
	end,
})

minetest.register_chatcommand("setday", {
	params = "<day>",
	description = "set the day",
	privs = {server=true},
	func = function(name, param)
		seasons.set_day(tonumber(param))
		minetest.chat_send_player(name, "Day was changed to "..param)
	end,
})

minetest.register_chatcommand("setyear", {
	params = "<year>",
	description = "set the year",
	privs = {server=true},
	func = function(name, param)
		seasons.set_year(tonumber(param))
		minetest.chat_send_player(name, "Year was changed to "..param)
	end,
})
