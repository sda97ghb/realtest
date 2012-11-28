local MUSICVOLUME = 1

local play_music = minetest.setting_getbool("music") or false
local music = {
	handler = {},
	{name="StrangelyBeautifulShort", length=3*60+.5, gain=0.3},
	{name="AvalonShort", length=2*60+58, gain=0.3},
	{name="eastern_feeling", length=3*60+51, gain=0.3},
	{name="EtherealShort", length=3*60+4, gain=0.3},
	{name="FarawayShort", length=3*60+5, gain=0.3},
	{name="dark_ambiance", length=44, gain=0.3}
}

-- start playing the sound, set the handler and delete the handler after sound is played
local play_sound = function(player, list, number)
	local player_name = player:get_player_name()
	if list.handler[player_name] == nil then
		local gain = 1.0
		if list[number].gain ~= nil then
			gain = list[number].gain*MUSICVOLUME
		end
		local handler = minetest.sound_play(list[number].name, {to_player=player_name, gain=gain})
		if handler ~= nil then
			list.handler[player_name] = handler
			minetest.after(list[number].length, function(args)
				local list = args[1]
				local player_name = args[2]
				if list.handler[player_name] ~= nil then
					minetest.sound_stop(list.handler[player_name])
					list.handler[player_name] = nil
				end
			end, {list, player_name})
		end
	end
end

local previous
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if math.random(1, 50) <= 7 then
			while true do
				local n = math.random(1, #music)
				if n ~= previous then
					play_sound(player, music, n)
					break
				end
			end
		end
	end
end)

minetest.register_chatcommand("music_volume", {
	params = "<volume>",
	description = "set volume of music, default 1 normal volume.",
	privs = {server=true},
	func = function(name, param)
		if param and tonumber(param) then
			MUSICVOLUME = param
			minetest.chat_send_player(name, "Music volume set.")
		end
	end,
})