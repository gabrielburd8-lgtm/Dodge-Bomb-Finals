extends Node

var player_1_color: Color = Color("#1677FF")
var player_2_color: Color = Color("#FF3B30")
var game_mode: String = "solo"

const PALETTE := [
    "#FF3B30",
    "#FF9500",
    "#FFD60A",
    "#A8E600",
    "#34C759",
    "#20C997",
    "#32D7F5",
    "#40A9FF",
    "#1677FF",
    "#5856D6",
    "#8B5CF6",
    "#BF5AF2",
    "#FF2D95",
    "#FF6B9A",
    "#FFFFFF"
]

func get_palette_colors() -> Array[Color]:
    var colors: Array[Color] = []
    for value in PALETTE:
        colors.append(Color(value))
    return colors
