jonez = {}

--Variables
local modname = "jonez"
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(minetest.get_current_modname())

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

minetest.register_node("jonez:marble", {
	description = S("Ancient Marble"),
	tiles = {"jonez_marble.png"},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

stairs.register_stair_and_slab(
	"marble",
	"jonez:marble",
	{choppy = 2, stone = 1},
	{"jonez_marble.png"},
	S("Ancient Marble Stair"),
	S("Ancient Marble Slab"),
	default.node_sound_stone_defaults()
)
stairs.register_stair_and_slab(
	"marble_brick",
	"jonez:marble_brick",
	{choppy = 2, stone = 1},
	{"jonez_marble_brick.png"},
	S("Ancient Marble Brick Stair"),
	S("Ancient Marble Brick Slab"),
	default.node_sound_stone_defaults()
)

minetest.register_node("jonez:marble_brick", {
	description = S("Ancient Marble Brick"),
	tiles = {"jonez_marble_brick.png"},
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = 'jonez:marble_bricks',
	recipe = {
		{'jonez:marble', 'jonez:marble'},
		{'jonez:marble', 'jonez:marble'},
	}
})

minetest.register_ore({
	ore_type = "scatter",
	ore = "jonez:marble",
	wherein = "default:stone",
	clust_scarcity = 7*7*7,
	clust_num_ores = 5,
	clust_size = 3,
	height_min = -31000,
	height_max = -1000,
	flags = "absheight",
})

local styles = {
	"roman",
	"greek",
	"germanic",
	"tuscan",
	"romanic"
}

--The chisel to carve the marble
minetest.register_craftitem("jonez:chisel", {
	description = S("Chisel for Marble"),
	inventory_image = "jonez_chisel.png",
	wield_image = "jonez_chisel.png^[transformR180"
})

minetest.register_craft({
	type = "shaped",
	output = "jonez:chisel",
	recipe = {
		{"", "", "default:diamond"},
		{"", "default:steel_ingot", ""},
		{"default:stick", "", ""},
	}
})

local function save_meta(pos, i, element)
	local meta = minetest.get_meta(pos)
	meta:set_int("jonez:style", i)
	meta:set_string("jonez:element", element)
end

local function on_punch(pos, player)
	local wielded_item = player:get_wielded_item()
	local wielded_item_name = wielded_item:get_name()
	if wielded_item_name == "jonez:chisel" then
		local meta = minetest.get_meta(pos)
		local style = meta:get_int("jonez:style")
		local element = meta:get_string("jonez:element")
		style = style + 1
		if style > # styles then
			style = 1
		end
		minetest.set_node(pos, {name= "jonez:"..styles[style].."_"..element})
		minetest.sound_play("jonez_carve", {pos = pos, gain = 0.7, max_hear_distance = 5})
	end
end

for i = 1, #styles do

	minetest.register_node("jonez:"..styles[i].."_architrave", {
		description = S("Ancient").." "..S(firstToUpper(styles[i])).." "..S("Architrave"),
		tiles = {"jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_architrave.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			save_meta(pos, i, "architrave")
		end,
		on_punch = function(pos, node, player, pointed_thing)
			on_punch(pos, player)
		end,
	})

	minetest.register_node("jonez:"..styles[i].."_capital", {
		description = S("Ancient").." "..S(firstToUpper(styles[i])).." "..S("Capital"),
		tiles = {"jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_capital.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			save_meta(pos, i, "capital")
		end,
		on_punch = function(pos, node, player, pointed_thing)
			on_punch(pos, player)
		end,
	})

	minetest.register_node("jonez:"..styles[i].."_shaft", {
		description = S("Ancient").." "..S(firstToUpper(styles[i])).." "..S("Shaft"),
		tiles = {"jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_shaft.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			save_meta(pos, i, "shaft")
		end,
		on_punch = function(pos, node, player, pointed_thing)
			on_punch(pos, player)
		end,
	})

	minetest.register_node("jonez:"..styles[i].."_base", {
		description = S("Ancient").." "..S(firstToUpper(styles[i])).." "..S("Base"),
		tiles = {"jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_top_bottom.png", "jonez_"..styles[i].."_base.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			save_meta(pos, i, "base")
		end,
		on_punch = function(pos, node, player, pointed_thing)
			on_punch(pos, player)
		end,
	})
end

local vines = {
	{name= "jonez:swedish_ivy", description= "Swedish Ivy", texture= "jonez_sweedish_ivy.png"},
	{name= "jonez:ruin_creeper", description= "Ruin Creeper", texture= "jonez_ruin_creeper.png"},
	{name= "jonez:ruin_vine", description= "Ruin Vine", texture= "jonez_ruin_vine.png"},
	{name= "jonez:climbing_rose", description= "Climbing Rose", texture= "jonez_climbing_rose.png"},
}

for i = 1, #vines do
	minetest.register_node(vines[i].name, {
		description = S(vines[i].description),
		drawtype = "nodebox",
		walkable = true,
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = {vines[i].texture},
		inventory_image = vines[i].texture,
		wield_image = vines[i].texture,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, 0.49, 0.5, 0.5, 0.5}
		},
		groups = {
			snappy = 2, flammable = 3, oddly_breakable_by_hand = 3, choppy = 2, carpet = 1, leafdecay = 3, leaves = 1
		},
		sounds = default.node_sound_leaves_defaults(),
	})
end

local panels = {
	{name= "jonez_panel_1", description= "Mosaic Glass Panel", texture="jonez_panel_1.png",
		recipe = {
			{"dye:blue", "dye:black", "dye:pink"},
			{"dye:red", "xpanes:pane_flat", "dye:green"},
			{"dye:yellow", "dye:black", "dye:orange"},
		}
	},
	{name= "jonez_panel_2", description= "Blossom Glass Panel", texture="jonez_panel_2.png",
		recipe = {
			{"dye:blue", "dye:red", "dye:green"},
			{"dye:yellow", "xpanes:pane_flat", "dye:yellow"},
			{"dye:green", "dye:red", "dye:orange"},
		}
	},
}

for j=1, #panels do
	xpanes.register_pane(panels[j].name, {
		description = S(panels[j].description),
		textures = {panels[j].texture, "", "xpanes_edge.png"},
		inventory_image = panels[j].texture,
		wield_image = panels[j].texture,
		sounds = default.node_sound_glass_defaults(),
		groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3},
		recipe = panels[j].recipe
	})
end

local pavements= {
	{name= "jonez:blossom_pavement", description= "Ancient Blossom Pavement", texture= "jonez_blossom_pavement.png",
		recipe = {
			{'', 'stairs:slab_marble', ''},
			{'stairs:slab_marble', 'stairs:slab_marble', 'stairs:slab_marble'},
			{'', 'stairs:slab_marble', ''},
		}
	},
	{name= "jonez:tiled_pavement", description= "Ancient Tiled Pavement", texture= "jonez_tiled_pavement.png",
		recipe = {
			{'stairs:slab_marble_brick', 'stairs:slab_marble_brick', ''},
			{'', 'stairs:slab_marble_brick', 'stairs:slab_marble_brick'},
			{'stairs:slab_marble_brick', 'stairs:slab_marble_brick', ''},
		}
	},
}

for i = 1, #pavements do
	minetest.register_node(pavements[i].name, {
		description = S(pavements[i].description),
		tiles = {pavements[i].texture},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})
	minetest.register_craft({
		output = pavements[i].name,
		type = 'shaped',
		recipe = pavements[i].recipe,
	})
end
