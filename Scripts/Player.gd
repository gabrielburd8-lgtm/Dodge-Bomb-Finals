extends Control

const SWATCH_SIZE := Vector2(52, 52)
const BACKGROUND_COLOR := Color("#071426")
const PANEL_COLOR := Color("#102B4C")
const BUTTON_COLOR := Color("#164B83")

var current_player: int = 1

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var player_selector: HBoxContainer = $MarginContainer/VBoxContainer/PlayerSelector
@onready var preview_panel: Panel = $MarginContainer/VBoxContainer/PreviewPanel
@onready var preview_color: ColorRect = $MarginContainer/VBoxContainer/PreviewPanel/PreviewColor
@onready var p1_button: Button = $MarginContainer/VBoxContainer/PlayerSelector/P1Button
@onready var p2_button: Button = $MarginContainer/VBoxContainer/PlayerSelector/P2Button
@onready var swatch_container: GridContainer = $MarginContainer/VBoxContainer/SwatchContainer
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton

func _ready() -> void:
    _apply_theme()
    _build_palette()
    _set_current_player(1)
    p1_button.pressed.connect(func() -> void:
        _set_current_player(1)
    )
    p2_button.pressed.connect(func() -> void:
        _set_current_player(2)
    )
    back_button.pressed.connect(_on_back_pressed)

func _apply_theme() -> void:
    title_label.add_theme_color_override("font_color", Color("#FFFFFF"))
    title_label.add_theme_font_size_override("font_size", 52)

    for button in [p1_button, p2_button, back_button]:
        button.modulate = BUTTON_COLOR
        button.add_theme_color_override("font_color", Color("#FFFFFF"))
        button.custom_minimum_size = Vector2(180, 48)

    preview_panel.modulate = PANEL_COLOR
    preview_color.color = Global.player_1_color

func _build_palette() -> void:
    for child in swatch_container.get_children():
        child.queue_free()

    var palette = Global.get_palette_colors()
    for color in palette:
        var swatch := Button.new()
        swatch.toggle_mode = true
        swatch.focus_mode = Control.FOCUS_NONE
        swatch.custom_minimum_size = SWATCH_SIZE
        swatch.modulate = color
        swatch.set_meta("color", color)
        swatch.pressed.connect(_on_swatch_pressed.bind(color))
        swatch_container.add_child(swatch)

    _refresh_palette_selection()

func _on_swatch_pressed(color: Color) -> void:
    if current_player == 1:
        Global.player_1_color = color
    else:
        Global.player_2_color = color

    _refresh_palette_selection()
    _update_preview()

func _set_current_player(player_number: int) -> void:
    current_player = player_number
    p1_button.button_pressed = current_player == 1
    p2_button.button_pressed = current_player == 2
    _refresh_palette_selection()
    _update_preview()

func _refresh_palette_selection() -> void:
    for child in swatch_container.get_children():
        if child is Button:
            var color: Color = child.get_meta("color")
            var selected_color: Color
            if current_player == 1:
                selected_color = Global.player_1_color
            else:
                selected_color = Global.player_2_color
            child.button_pressed = color == selected_color

func _update_preview() -> void:
    if current_player == 1:
        preview_color.color = Global.player_1_color
    else:
        preview_color.color = Global.player_2_color

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
