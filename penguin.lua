
local S = core.get_translator("mobs_animal")

-- Penguin by D00Med

mobs:register_mob("mobs_animal:penguin", {
stepheight = 0.6,
	type = "animal",
	passive = true,
	reach = 1,
	hp_min = 5,
	hp_max = 10,
	armor = 100,
	collisionbox = {-0.2, -0.0, -0.2,  0.2, 0.5, 0.2},
	visual = "mesh",
	mesh = "mobs_penguin.b3d",
	visual_size = {x = 0.25, y = 0.25},
	textures = {{"mobs_penguin.png"}},
	sounds = {},
	makes_footstep_sound = true,
	walk_velocity = 1,
	run_velocity = 2,
	runaway = true,
	jump = false,
	stepheight = 1.1,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1}
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 2,
	animation = {
		speed_normal = 15,
		stand_start = 1, stand_end = 20,
		walk_start = 25, walk_end = 45,
		fly_start = 75, fly_end = 95 -- swim animation
		-- 50-70 is slide/water idle
	},
	fly_in = {"default:water_source", "default:water_flowing"},
	floats = 0,
	follow = {
		"group:food_fish_raw", "mobs_fish:clownfish", "mobs_fish:tropical",
		"mobs_fish:clownfish_set", "mobs_fish:tropical_set", "xocean:fish_edible"
	},
	view_range = 5,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 5, 50, 80, false, nil) then return end
	end
})

-- where to spawn

if not mobs.custom_spawn_animal then

	mobs:spawn({
		name = "mobs_animal:penguin",
		nodes = {"default:snowblock"},
		min_light = 14,
		interval = 60,
		chance = 20000,
		min_height = 0,
		max_height = 200,
		day_toggle = true
	})
end

-- spawn egg

mobs:register_egg("mobs_animal:penguin", S("Penguin"), "mobs_penguin_inv.png")
