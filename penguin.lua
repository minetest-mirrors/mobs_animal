
local S = core.get_translator("mobs_animal")

-- Penguin by D00Med

mobs:register_mob("mobs_animal:penguin", {
	description = S("Penguin"),
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
	jump_height = 3,
	stepheight = 1.1,
	drops = {
		{name = "mobs:chicken_raw", chance = 1, min = 1, max = 1}
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
	animation = {
		speed_normal = 15,
		stand_start = 1, stand_end = 20,
		walk_start = 25, walk_end = 45,
		glide_start = 50, glide_end = 70, -- slide/water idle
		fly_start = 75, fly_end = 95, -- swim animation
	},
	fly_in = {"group:water"},
	floats = nil,
	follow = {
		"group:food_fish_raw", "mobs_fish:clownfish", "mobs_fish:tropical",
		"mobs_fish:clownfish_set", "mobs_fish:tropical_set", "xocean:fish_edible",
		"group:fish"
	},
	view_range = 5,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 5, 50, 80, false, nil) then return end
	end,

	do_custom = function(self, dtime)

		self.temp.swim_timer = (self.temp.swim_timer or 0) + dtime
		if self.temp.swim_timer < 0.5 then return end
		self.temp.swim_timer = 0

		-- are we under, in, on water, get speed
		local un_water = core.get_item_group(self.looking_above, "water") > 0
		local in_water = core.get_item_group(self.standing_in, "water") > 0
		local on_water = core.get_item_group(self.standing_on, "water") > 0

		-- when sliding into water switch to fly mode and speed up swimming
		if not self.fly and (in_water or on_water) then
			self.fly = true ; self.walk_velocity = 2
			self.object:set_acceleration({x = 0, y = 0, z = 0})
		end

		-- when in water and breaking surface try to leap
		if self.fly and not un_water and math.random(7) == 1 then

			local vel = self.object:get_velocity() or {x = 0, y = 0, z = 0}
			local yaw = self.object:get_yaw() or 0
			local boost = self.jump_height * 0.35

			vel.y = self.jump_height
			vel.x = (vel.x or 0) - math.sin(yaw) * boost
			vel.z = (vel.z or 0) + math.cos(yaw) * boost

			self.object:set_velocity(vel)
		end

		-- when coming out of water switch fly off and go back to normal walk speed
		if self.fly and not in_water and not on_water then
			self.fly = nil ; self.walk_velocity = 1
		end
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
