extends Control

const SWATCH_SIZE := Vector2(50, 50)

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
    _build_palette()
    _update_preview()
    p1_button.pressed.connect(func() -> void:
        current_player = 1
        _update_preview()
    )
    p2_button.pressed.connect(func() -> void:
        current_player = 2
        _update_preview()
    )
    back_button.pressed.connect(_on_back_pressed)

func _build_palette() -> void:
    for child in swatch_container.get_children():
        child.queue_free()
    var palette = Global.get_palette_colors()
    for color in palette:
        var button := Button.new()
        button.custom_minimum_size = SWATCH_SIZE
        button.modulate = color
        button.pressed.connect(_on_swatch_pressed.bind(color))
        swatch_container.add_child(button)

func _on_swatch_pressed(color: Color) -> void:
    if current_player == 1:
        Global.player_1_color = color
    else:
        Global.player_2_color = color
    _update_preview()

func _update_preview() -> void:
    if current_player == 1:
        p1_button.button_pressed = true
        p2_button.button_pressed = false
        preview_color.color = Global.player_1_color
    else:
        p1_button.button_pressed = false
        p2_button.button_pressed = true
        preview_color.color = Global.player_2_color

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
