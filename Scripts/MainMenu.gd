extends Control

@onready var solo_button: Button = $MarginContainer/VBoxContainer/SoloButton
@onready var versus_button: Button = $MarginContainer/VBoxContainer/VersusButton
@onready var color_button: Button = $MarginContainer/VBoxContainer/ColorButton
@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton

func _ready() -> void:
    solo_button.pressed.connect(_on_solo_pressed)
    versus_button.pressed.connect(_on_versus_pressed)
    color_button.pressed.connect(_on_color_pressed)
    exit_button.pressed.connect(_on_exit_pressed)

func _on_solo_pressed() -> void:
    Global.game_mode = "solo"
    get_tree().change_scene_to_file("res://Scenes/Arena.tscn")

func _on_versus_pressed() -> void:
    Global.game_mode = "versus"
    get_tree().change_scene_to_file("res://Scenes/Arena.tscn")

func _on_color_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/PlayerColorMenu.tscn")

func _on_exit_pressed() -> void:
    get_tree().quit()
