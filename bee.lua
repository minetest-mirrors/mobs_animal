
local S = core.get_translator("mobs_animal")

-- Bee by KrupnoPavel (.b3d model by sirrobzeroone)

mobs:register_mob("mobs_animal:bee", {
	type = "animal",
	passive = true,
	hp_min = 1,
	hp_max = 2,
	armor = 100,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.5, 0.2},
	visual = "mesh",
	mesh = "mobs_bee.b3d",
	textures = { {"mobs_bee.png"} },
	blood_texture = "mobs_bee_inv.png",
	blood_amount = 1,
	makes_footstep_sound = false,
	sounds = { random = "mobs_bee" },
	walk_velocity = 1,
	jump = true,
	drops = {
		{name = "mobs:honey", chance = 2, min = 1, max = 2}
	},
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -3,
	animation = {
		speed_normal = 15,
		stand_start = 0, stand_end = 30,
		walk_start = 35, walk_end = 65
	},

	on_rightclick = function(self, clicker)
		mobs:capture_mob(self, clicker, 50, 90, 0, true, "mobs_animal:bee")
	end,

--	after_activate = function(self, staticdata, def, dtime)
--		print ("------", self.name, dtime, self.health)
--	end,
})

-- where to spawn

if not mobs.custom_spawn_animal then

	mobs:spawn({
		name = "mobs_animal:bee",
		nodes = {"group:flower"},
		min_light = 14,
		interval = 60,
		chance = 7000,
		min_height = 3,
		max_height = 200,
		day_toggle = true
	})
end

-- spawn egg

mobs:register_egg("mobs_animal:bee", S("Bee"), "mobs_bee_inv.png")

-- compatibility (only required if moving from old mobs to mobs_redo)

mobs:alias_mob("mobs:bee", "mobs_animal:bee")

-- honey

core.register_craftitem(":mobs:honey", {
	description = S("Honey"),
	inventory_image = "mobs_honey_inv.png",
	on_use = core.item_eat(4),
	groups = {food_honey = 1, food_sugar = 1}
})

mobs.add_eatable("mobs:honey", 4)

-- beehive (1 in 4 chance of spawning bee when placed)

core.register_node(":mobs:beehive", {
	description = S("Beehive"),
	drawtype = "plantlike",
	tiles = {"mobs_beehive.png"},
	inventory_image = "mobs_beehive.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = true,
	groups = {oddly_breakable_by_hand = 3, flammable = 1, disable_suffocation = 1},
	is_ground_content = false,
	sounds = mobs.node_sound_defaults(),

	on_construct = function(pos)

		local meta = core.get_meta(pos)
		local gui_bg = default and default.gui_bg .. default.gui_bg_img .. default.gui_slots or ""

		meta:set_string("formspec", "size[8,6]"
			.. gui_bg
			.. "image[3,0.8;0.8,0.8;mobs_bee_inv.png]"
			.. "list[current_name;beehive;4,0.5;1,1;]"
			.. "list[current_player;main;0,2.35;8,4;]"
			.. "listring[]")

		meta:get_inventory():set_size("beehive", 1)
	end,

	after_place_node = function(pos, placer, itemstack)

		if placer and placer:is_player() then

			core.set_node(pos, {name = "mobs:beehive", param2 = 1})

			if math.random(4) == 1 then
				core.add_entity(pos, "mobs_animal:bee")
			end
		end
	end,

	on_punch = function(pos, node, puncher)

		-- yep, bee's don't like having their home punched by players
		core.after(0.2, function()

			local hp = puncher and puncher:get_hp()

			if hp then puncher:set_hp(hp - 4) end
		end)
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)

		if listname == "beehive" then return 0 end

		return stack:get_count()
	end,

	can_dig = function(pos,player) -- can only dig when no honey inside

		local meta = core.get_meta(pos)

		return meta:get_inventory():is_empty("beehive")
	end
})

-- beehive recipe

core.register_craft({
	output = "mobs:beehive",
	recipe = {{"mobs:bee","mobs:bee","mobs:bee"}}
})

-- honey block and craft recipes

core.register_node(":mobs:honey_block", {
	description = S("Honey Block"),
	tiles = {"mobs_honey_block.png"},
	groups = {snappy = 3, flammable = 2},
	is_ground_content = false,
	sounds = mobs.node_sound_dirt_defaults()
})

core.register_craft({
	output = "mobs:honey_block",
	recipe = {
		{"mobs:honey", "mobs:honey", "mobs:honey"},
		{"mobs:honey", "mobs:honey", "mobs:honey"},
		{"mobs:honey", "mobs:honey", "mobs:honey"}
	}
})

core.register_craft({
	output = "mobs:honey 9",
	recipe = {
		{"mobs:honey_block"}
	}
})

-- beehive workings

core.register_abm({
	nodenames = {"mobs:beehive"},
	interval = 12,
	chance = 6,
	catch_up = false,

	action = function(pos, node)

		-- bee's only make honey during the day
		local tod = (core.get_timeofday() or 0) * 24000

		if tod < 5500 or tod > 18500 then return end

		local meta = core.get_meta(pos) ; if not meta then return end
		local inv = meta:get_inventory()
		local honey = inv:get_stack("beehive", 1):get_count()

		if honey > 11 then return end -- return if hive full

		-- no flowers no honey, nuff said!
		if #core.find_nodes_in_area_under_air(
				{x = pos.x - 4, y = pos.y - 3, z = pos.z - 4},
				{x = pos.x + 4, y = pos.y + 3, z = pos.z + 4}, "group:flower") > 3 then

			inv:add_item("beehive", "mobs:honey")
		end
	end
})
