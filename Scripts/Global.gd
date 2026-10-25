extends Node

const COLORS := [
    Color("#FF3B30"),
    Color("#FF9500"),
    Color("#FFD60A"),
    Color("#34C759"),
    Color("#1677FF"),
    Color("#4F46E5"),
    Color("#8B5CF6")
]

var player_1_color: Color = COLORS[0]
var player_2_color: Color = COLORS[4]
var selected_solo_color: Color = COLORS[0]
var game_mode: String = "solo"

func get_palette_colors() -> Array[Color]:
    return COLORS.duplicate()

func color_matches(a: Color, b: Color) -> bool:
    return abs(a.r - b.r) < 0.01 and abs(a.g - b.g) < 0.01 and abs(a.b - b.b) < 0.01

func get_ability_for_color(color: Color) -> String:
    if color_matches(color, COLORS[0]):
        return "dash"
    if color_matches(color, COLORS[4]):
        return "shield"
    return "none"
