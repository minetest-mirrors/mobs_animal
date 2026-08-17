
local S = core.get_translator("mobs_animal")

-- pig adoption

local function pig_adoption(pos, player)

	local name = player:get_player_name() or ""
	local col = core.get_color_escape_sequence("#e35d86")

	lucky_block:msg(player, col .. S("You've adopted a baby!"))

	mobs:add_mob(pos, {
		name = "mobs_animal:pumba", child = true, owner = name, nametag = "Baby #1",
		ignore_count = true
	})

	core.after(3, function()

		lucky_block:msg(player, col .. S("Twins!!"))

		mobs:add_mob(pos, {
			name = "mobs_animal:pumba", child = true, owner = name, nametag = "Baby #2",
			ignore_count = true
		})
	end)

	core.after(6, function()

		lucky_block:msg(player, col .. S("Triplets!!!"))

		mobs:add_mob(pos, {
			name = "mobs_animal:pumba", child = true, owner = name, nametag = "Baby #3",
			ignore_count = true
		})
	end)
end

-- add lucky blocks

lucky_block:add_blocks({
	{"spw", "mobs_animal:sheep", 5},
	{"spw", "mobs_animal:rat", 5},
	{"dro", {"mobs:rat_cooked"}, 5},
	{"spw", "mobs_animal:bunny", 3},
	{"nod", "mobs:honey_block", 0},
	{"spw", "mobs_animal:pumba", 5},
	{"nod", "mobs:cheeseblock", 0},
	{"spw", "mobs_animal:chicken", 5},
	{"dro", {"mobs:egg"}, 5},
	{"spw", "mobs_animal:cow", 5},
	{"dro", {"mobs:bucket_milk", "bucket:bucket_water"}, 8},
	{"spw", "mobs_animal:kitten", 2},
	{"exp"},
	{"dro", {"mobs:hairball"}, 3},
	{"dro", {"mobs:chicken_raw", "mobs:chicken_cooked"}, 10},
	{"dro", {"mobs:pork_raw", "mobs:pork_cooked"}, 10},
	{"dro", {"mobs:mutton_raw", "mobs:mutton_cooked"}, 10},
	{"dro", {"mobs:meat_raw", "mobs:meat"}, 10},
	{"dro", {"mobs:glass_milk"}, 5},
	{"spw", "mobs_animal:penguin", 2},
	{"cus", pig_adoption}
})

-- if nyancat found add special block

if core.registered_nodes["default:nyancat"] then

	lucky_block:add_blocks({
		{"tro", "default:nyancat", "mobs_kitten", true}
	})
end
