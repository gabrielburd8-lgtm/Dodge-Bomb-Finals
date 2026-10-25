extends Control

@onready var solo_button: Button = $MarginContainer/VBoxContainer/SoloButton
@onready var versus_button: Button = $MarginContainer/VBoxContainer/VersusButton
@onready var color_button: Button = $MarginContainer/VBoxContainer/ColorButton
@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton

func _ready() -> void:
    _apply_theme()
    solo_button.pressed.connect(_on_solo_pressed)
    versus_button.pressed.connect(_on_versus_pressed)
    color_button.pressed.connect(_on_color_pressed)
    exit_button.pressed.connect(_on_exit_pressed)

func _apply_theme() -> void:
    self.modulate = Color(1, 1, 1, 1)
    for button in [solo_button, versus_button, color_button, exit_button]:
        button.focus_mode = Control.FOCUS_ALL
        button.modulate = Color("#164B83")
        button.add_theme_color_override("font_color", Color("#F2F9FF"))
        button.add_theme_color_override("font_hover_color", Color("#F2F9FF"))
        button.add_theme_color_override("font_pressed_color", Color("#B8D9FF"))
        button.custom_minimum_size = Vector2(360, 68)
        button.add_theme_font_size_override("font_size", 24)

func _on_solo_pressed() -> void:
    Global.game_mode = "solo"
    get_tree().change_scene_to_file("res://Scenes/PlayerColorMenu.tscn")

func _on_versus_pressed() -> void:
    Global.game_mode = "versus"
    get_tree().change_scene_to_file("res://Scenes/PlayerColorMenu.tscn")

func _on_color_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/PlayerColorMenu.tscn")

func _on_exit_pressed() -> void:
    get_tree().quit()
