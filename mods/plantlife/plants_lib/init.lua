-- Plantlife mod by Vanessa Ezekowitz
-- 2012-11-29
--
-- This mod combines all of the functionality from poison ivy,
-- flowers, and jungle grass.  If you have any of these, you no
-- longer need them.
--
-- License:
--	CC-BY-SA for most textures, except flowers
--	WTFPL for the flowers textures
--	WTFPL for all code and everything else

-- Various settings - most of these probably won't need to be changed

local plantlife_debug = false  -- ...unless you want the modpack to spam the console ;-)

local plantlife_seed_diff = 123
local perlin_octaves = 3
local perlin_persistence = 0.2
local perlin_scale = 25

local plantlife_limit = 0.1 -- compared against perlin noise.  lower = more abundant

local flowers_seed_diff = plantlife_seed_diff
local junglegrass_seed_diff = plantlife_seed_diff + 10
local poisonivy_seed_diff = plantlife_seed_diff + 10

-- Local functions

math.randomseed(os.time())

local dbg = function(s)
	if plantlife_debug then
		print("[Plantlife] " .. s)
	end
end

local is_node_loaded = function(node_pos)
	n = minetest.env:get_node_or_nil(node_pos)
	if (n == nil) or (n.name == "ignore") then
		return false
	end
	return true
end

-- The spawning ABM

spawn_on_surfaces = function(sdelay, splant, sradius, schance, ssurface, savoid, seed_diff, lightmin, lightmax, nneighbors, ocount, facedir, depthmax)
	if seed_diff == nil then seed_diff = 0 end
	if lightmin == nil then lightmin = 0 end
	if lightmax == nil then lightmax = LIGHT_MAX end
	if nneighbors == nil then nneighbors = ssurface end
	if ocount == nil then ocount = 0 end
	if depthmax == nil then depthmax = 1 end
	minetest.register_abm({
		nodenames = { ssurface },
		interval = sdelay,
		chance = schance,
		neighbors = nneighbors,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }	
			local n_top = minetest.env:get_node(p_top)
			local perlin = minetest.env:get_perlin(seed_diff, perlin_octaves, perlin_persistence, perlin_scale )
			local noise = perlin:get2d({x=p_top.x, y=p_top.z})
			if ( noise > plantlife_limit ) and (n_top.name == "air") and is_node_loaded(p_top) then
				local n_light = minetest.env:get_node_light(p_top, nil)
				if (minetest.env:find_node_near(p_top, sradius + math.random(-1.5,2), savoid) == nil )
				   and (n_light >= lightmin)
				   and (n_light <= lightmax)
				and table.getn(minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, nneighbors)) > ocount 
				then
					local walldir = plant_valid_wall(p_top)
					if splant == "poisonivy:seedling" and walldir ~= nil then
						dbg("Spawn: poisonivy:climbing at "..dump(p_top).." on "..ssurface)
						minetest.env:add_node(p_top, { name = "poisonivy:climbing", param2 = walldir })
					else
						local deepnode = minetest.env:get_node({ x = pos.x, y = pos.y-depthmax-1, z = pos.z }).name
						if (ssurface ~= "default:water_source")
							or (ssurface == "default:water_source"
							and deepnode ~= "default:water_source") then
							dbg("Spawn: "..splant.." at "..dump(p_top).." on "..ssurface)
							minetest.env:add_node(p_top, { name = splant, param2 = facedir })
						end
					end
				end
			end
		end
	})
end

-- The growing ABM

grow_plants = function(gdelay, gchance, gplant, gresult, dry_early_node, grow_nodes, facedir)
	minetest.register_abm({
		nodenames = { gplant },
		interval = gdelay,
		chance = gchance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.env:get_node(p_top)
			local n_bot = minetest.env:get_node(p_bot)

			if string.find(dump(grow_nodes), n_bot.name) ~= nil and n_top.name == "air" then

				-- corner case for wall-climbing poison ivy
				if gplant == "poisonivy:climbing" then
					local walldir=plant_valid_wall(p_top)
					if walldir ~= nil then
						dbg("Grow: "..gplant.." upwards to ("..dump(p_top)..")")
						minetest.env:add_node(p_top, { name = gplant, param2 = walldir })
					end

				-- corner case for changing short junglegrass to dry shrub in desert
				elseif n_bot.name == dry_early_node and gplant == "junglegrass:short" then
					dbg("Die: "..gplant.." becomes default:dry_shrub at ("..dump(pos)..")")
					minetest.env:add_node(pos, { name = "default:dry_shrub" })

				elseif gresult == nil then
					dbg("Die: "..gplant.." at ("..dump(pos)..")")
					minetest.env:remove_node(pos)

				elseif gresult ~= nil then
					dbg("Grow: "..gplant.." becomes "..gresult.." at ("..dump(pos)..")")
					if facedir == nil then
						minetest.env:add_node(pos, { name = gresult })
					else
						minetest.env:add_node(pos, { name = gresult, param2 = facedir })
					end
				end
			end
		end
	})
end

-- function to decide if a node has a wall that's in verticals_list{}
-- returns wall direction of valid node, or nil if invalid.

plant_valid_wall = function(wallpos)
	local walldir = nil
	local verts = dump(verticals_list)

	local testpos = { x = wallpos.x-1, y = wallpos.y, z = wallpos.z   }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=3 end

	local testpos = { x = wallpos.x+1, y = wallpos.y, z = wallpos.z   }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=2 end

	local testpos = { x = wallpos.x  , y = wallpos.y, z = wallpos.z-1 }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=5 end

	local testpos = { x = wallpos.x  , y = wallpos.y, z = wallpos.z+1 }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=4 end

	return walldir
end

local enstr = ""

if enabled_flowers then enstr = enstr.." flowers" end
if enabled_junglegrass then enstr = enstr.." junglegrass" end
if enabled_poisonivy then enstr = enstr.." poisonivy" end

if enstr == "" then enstr = "...er...nothing!" end

print("[Plantlife] Loaded (enabled"..enstr..")")
