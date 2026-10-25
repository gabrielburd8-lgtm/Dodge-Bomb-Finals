extends Control

const NAVY_BG := Color("#071426")
const PANEL_BG := Color("#102B4C")
const BUTTON_BG := Color("#164B83")
const TEXT_LIGHT := Color("#F2F9FF")

var current_player: int = 1
var player_1_color: Color = Global.player_1_color
var player_2_color: Color = Global.player_2_color

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var mode_label: Label = $MarginContainer/VBoxContainer/ModeLabel
@onready var preview_p1: ColorRect = $MarginContainer/VBoxContainer/SelectorRow/P1Section/Player1Panel/PreviewColor
@onready var preview_p2: ColorRect = $MarginContainer/VBoxContainer/SelectorRow/P2Section/Player2Panel/PreviewColor
@onready var swatch_container: GridContainer = $MarginContainer/VBoxContainer/SwatchContainer
@onready var start_button: Button = $MarginContainer/VBoxContainer/ButtonsRow/StartButton
@onready var back_button: Button = $MarginContainer/VBoxContainer/ButtonsRow/BackButton

func _ready() -> void:
    _apply_theme()
    _build_palette()
    _update_previews()
    _refresh_palette_selection()

func _apply_theme() -> void:
    title_label.add_theme_color_override("font_color", TEXT_LIGHT)
    title_label.add_theme_font_size_override("font_size", 34)
    mode_label.add_theme_color_override("font_color", Color("#B8D9FF"))
    mode_label.add_theme_font_size_override("font_size", 18)

    for button in [start_button, back_button]:
        button.modulate = BUTTON_BG
        button.add_theme_color_override("font_color", TEXT_LIGHT)
        button.add_theme_font_size_override("font_size", 18)

func _build_palette() -> void:
    for child in swatch_container.get_children():
        child.queue_free()

    for color in Global.get_palette_colors():
        var swatch := Button.new()
        swatch.toggle_mode = true
        swatch.focus_mode = Control.FOCUS_NONE
        swatch.custom_minimum_size = Vector2(48, 42)
        swatch.modulate = color
        swatch.set_meta("color", color)
        swatch.pressed.connect(_on_swatch_pressed.bind(color))
        swatch_container.add_child(swatch)

    _refresh_palette_selection()

func _on_swatch_pressed(color: Color) -> void:
    if Global.game_mode == "solo":
        player_1_color = color
        player_2_color = color
        Global.selected_solo_color = color
    elif current_player == 1:
        player_1_color = color
    else:
        player_2_color = color

    _refresh_palette_selection()
    _update_previews()

func _refresh_palette_selection() -> void:
    for child in swatch_container.get_children():
        if child is Button:
            var swatch_color: Color = child.get_meta("color")
            var selected_color: Color = player_1_color if current_player == 1 else player_2_color
            var other_color: Color = player_2_color if current_player == 1 else player_1_color
            child.button_pressed = Global.color_matches(swatch_color, selected_color)
            child.disabled = Global.color_matches(swatch_color, other_color) and not Global.color_matches(swatch_color, selected_color)
            child.modulate = swatch_color

func _update_previews() -> void:
    preview_p1.color = player_1_color
    preview_p2.color = player_2_color
    mode_label.text = "SOLO" if Global.game_mode == "solo" else "LOCAL MULTIPLAYER"

func _on_start_pressed() -> void:
    if Global.game_mode == "solo":
        Global.player_1_color = player_1_color
        Global.player_2_color = player_1_color
        Global.selected_solo_color = player_1_color
        get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
        return

    if player_1_color == player_2_color:
        return

    Global.player_1_color = player_1_color
    Global.player_2_color = player_2_color
    get_tree().change_scene_to_file("res://Scenes/Arena.tscn")

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
