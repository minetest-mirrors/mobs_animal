local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

-- Check for translation method
local S
if minetest.get_translator ~= nil then
	S = minetest.get_translator("mobs_animal") -- 5.x translation function
else
	if minetest.get_modpath("intllib") then
		dofile(minetest.get_modpath("intllib") .. "/init.lua")
		if intllib.make_gettext_pair then
			S = intllib.make_gettext_pair() -- new gettext method
		else
			S = intllib.Getter() -- old text file method
		end
	else -- boilerplate function
		S = function(str, ...)
			local args = {...}
			return str:gsub("@%d+", function(match)
				return args[tonumber(match:sub(2))]
			end)
		end
	end
end

mobs.intllib_animal = S


-- Check for custom mob spawn file
local input = io.open(path .. "spawn.lua", "r")

if input then
	mobs.custom_spawn_animal = true
	input:close()
	input = nil
end


-- helper function
local function ddoo(mob)

	if minetest.settings:get_bool("mobs_animal." .. mob) == false then
		print("[Mobs_Animal] " .. mob .. " disabled!")
		return
	end

	dofile(path .. mob .. ".lua")
end

-- Animals
ddoo("chicken") -- JKmurray
ddoo("cow") -- KrupnoPavel
ddoo("rat") -- PilzAdam
ddoo("sheep") -- PilzAdam
ddoo("warthog") -- KrupnoPavel
ddoo("bee") -- KrupnoPavel
ddoo("bunny") -- ExeterDad
ddoo("kitten") -- Jordach/BFD
ddoo("penguin") -- D00Med
ddoo("panda") -- AspireMint


-- Load custom spawning
if mobs.custom_spawn_animal then
	dofile(path .. "spawn.lua")
end


-- Lucky Blocks
if minetest.get_modpath("lucky_block") then
	dofile(path .. "lucky_block.lua")
end


print ("[MOD] Mobs Redo Animals loaded")
