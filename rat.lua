
local S = core.get_translator("mobs_animal")

-- Rat by Melkor (model and textures)

mobs:register_mob("mobs_animal:rat", {
	description = S("Rat"),
	stepheight = 1.1,
	type = "animal",
	passive = true,
	hp_min = 2,
	hp_max = 5,
	view_range = 6,
	armor = 100,
	collisionbox = {-0.12, 0, -0.12, 0.12, 0.1, 0.12},
	visual = "mesh",
	mesh = "mobs_rat.b3d",
	rotate = 180,
	textures = {
		{"mobs_rat.png"},
		{"mobs_rat2.png"},
		{"mobs_rat3.png"},
		{"mobs_rat4.png"}
	},
	makes_footstep_sound = false,
	sounds = {random = "mobs_rat"},
	walk_velocity = 1.5,
	run_velocity = 3,
	runaway = true,
	water_damage = 0.01,
	lava_damage = 4,
	fire_damage = 4,
	light_damage = 0,
	fear_height = 3,
	follow = {"group:food_cheese", "group:seed"},
	replace_what = {
		"group:food_cheese", "group:seed", "farming:barley_7", "farming:barley_8",
		"farming:wheat_7", "farming:wheat_8", "farming:corn_7", "farming:corn_8"
	},
	replace_with = "air", replace_rate = 10,

	on_rightclick = function(self, clicker)

		if mobs:feed_tame(self, clicker, 4, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 50, 90, 0, true) then return end
	end,
--[[
	do_custom = function(self, dtime)

		self.rat_timer = (self.rat_timer or 0) + dtime

		if self.rat_timer < 1 then return end -- every 1 second

		self.rat_timer = 0

		local pos = self.object:get_pos()

		print("rat pos", pos.x, pos.y, pos.z, dtime)

		return false -- return but skip doing rest of API
	end,
]]
--[[
	on_blast = function(obj, damage)
		print ("--- damage is", damage)
		print ("---    mob is", obj.object:get_luaentity().name)
		-- return's do_damage, do_knockback and drops
		return false, true, {"default:mese"}
	end,
]]
})

-- example on_spawn function (battle rats)

local function rat_spawn(self, pos)
	self = self:get_luaentity()
	self.hp_max = 100
	self.health = 100
	self.passive = false
	self.attack_chance = 50
	self.attack_type = "dogfight"
	self.damage = 2
	self.group_attack = true
end

-- where to spawn

if not mobs.custom_spawn_animal then

	mobs:spawn({
		name = "mobs_animal:rat",
		nodes = {"default:stone"},
		min_light = 3,
		max_light = 9,
		interval = 60,
		chance = 8000,
		max_height = 0,
--		on_spawn = rat_spawn,
	})
end

-- spawn egg

mobs:register_egg("mobs_animal:rat", S("Rat"), "mobs_rat_inv.png")

-- compatibility with older mobs mod

mobs:alias_mob("mobs:rat", "mobs_animal:rat")

-- cooked rat, yummy!

core.register_craftitem(":mobs:rat_cooked", {
	description = S("Cooked Rat"),
	inventory_image = "mobs_cooked_rat.png",
	on_use = core.item_eat(3),
	groups = {food_rat = 1}
})

mobs.add_eatable("mobs:rat_cooked", 3)

core.register_craft({
	type = "cooking",
	output = "mobs:rat_cooked",
	recipe = "mobs_animal:rat",
	cooktime = 5
})


core.register_craft({
	type = "cooking",
	output = "mobs:rat_cooked",
	recipe = "mobs_animal:rat_set",
	cooktime = 5
})
