extends Control

var solo_button: Button
var versus_button: Button
var color_button: Button
var exit_button: Button

func _ready() -> void:
    _build_ui()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    bg.color = Color("#071426")
    add_child(bg)

    var margin := MarginContainer.new()
    margin.set_anchors_preset(Control.PRESET_FULL_RECT)
    margin.offset_left = 80
    margin.offset_top = 80
    margin.offset_right = -80
    margin.offset_bottom = -80
    add_child(margin)

    var vbox := VBoxContainer.new()
    vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    vbox.theme_override_constants/separation = 18
    margin.add_child(vbox)

    var title_label := Label.new()
    title_label.text = "DODGE BOMB"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 82)
    title_label.add_theme_color_override("font_color", Color("#F2F9FF"))
    vbox.add_child(title_label)

    var button_container := VBoxContainer.new()
    button_container.custom_minimum_size = Vector2(420, 0)
    button_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    button_container.theme_override_constants/separation = 16
    vbox.add_child(button_container)

    solo_button = Button.new()
    solo_button.text = "Solo Mode"
    solo_button.custom_minimum_size = Vector2(0, 64)
    solo_button.modulate = Color("#164B83")
    solo_button.add_theme_color_override("font_color", Color("#F2F9FF"))
    solo_button.add_theme_font_size_override("font_size", 24)
    solo_button.focus_mode = Control.FOCUS_ALL
    solo_button.pressed.connect(_on_solo_pressed)
    button_container.add_child(solo_button)

    versus_button = Button.new()
    versus_button.text = "Local Multiplayer"
    versus_button.custom_minimum_size = Vector2(0, 64)
    versus_button.modulate = Color("#164B83")
    versus_button.add_theme_color_override("font_color", Color("#F2F9FF"))
    versus_button.add_theme_font_size_override("font_size", 24)
    versus_button.focus_mode = Control.FOCUS_ALL
    versus_button.pressed.connect(_on_versus_pressed)
    button_container.add_child(versus_button)

    color_button = Button.new()
    color_button.text = "Player Colors"
    color_button.custom_minimum_size = Vector2(0, 64)
    color_button.modulate = Color("#164B83")
    color_button.add_theme_color_override("font_color", Color("#F2F9FF"))
    color_button.add_theme_font_size_override("font_size", 24)
    color_button.focus_mode = Control.FOCUS_ALL
    color_button.pressed.connect(_on_color_pressed)
    button_container.add_child(color_button)

    exit_button = Button.new()
    exit_button.text = "Exit Game"
    exit_button.custom_minimum_size = Vector2(0, 64)
    exit_button.modulate = Color("#164B83")
    exit_button.add_theme_color_override("font_color", Color("#F2F9FF"))
    exit_button.add_theme_font_size_override("font_size", 24)
    exit_button.focus_mode = Control.FOCUS_ALL
    exit_button.pressed.connect(_on_exit_pressed)
    button_container.add_child(exit_button)

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
