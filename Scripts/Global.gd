extends Node

var player_1_color: Color = Color("#FF3B30")
var player_2_color: Color = Color("#1677FF")
var selected_solo_color: Color = Color("#FF3B30")
var game_mode: String = "solo"

const RED := Color("#FF3B30")
const ORANGE := Color("#FF9500")
const YELLOW := Color("#FFD60A")
const GREEN := Color("#34C759")
const BLUE := Color("#1677FF")
const INDIGO := Color("#4F46E5")
const VIOLET := Color("#8B5CF6")

const PALETTE := [
    RED,
    ORANGE,
    YELLOW,
    GREEN,
    BLUE,
    INDIGO,
    VIOLET,
]

func get_palette_colors() -> Array[Color]:
    return PALETTE.duplicate()

func color_matches(a: Color, b: Color) -> bool:
    return abs(a.r - b.r) < 0.01 and abs(a.g - b.g) < 0.01 and abs(a.b - b.b) < 0.01

func get_ability_for_color(color: Color) -> String:
    if color_matches(color, RED):
        return "dash"
    if color_matches(color, BLUE):
        return "shield"
    return "none"

func is_valid_player_color(color: Color) -> bool:
    for candidate in PALETTE:
        if color_matches(candidate, color):
            return true
    return false
