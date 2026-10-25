extends Control

const NAVY_BG := Color("#071426")
const PANEL_BG := Color("#102B4C")
const BUTTON_BG := Color("#164B83")
const TEXT_LIGHT := Color("#F2F9FF")

var current_player: int = 1
var p1_color: Color = Global.player_1_color
var p2_color: Color = Global.player_2_color

var title_label: Label
var mode_label: Label
var p1_box: VBoxContainer
var p2_box: VBoxContainer
var preview_p1: ColorRect
var preview_p2: ColorRect
var swatch_grid: GridContainer
var start_button: Button
var back_button: Button

func _ready() -> void:
    _build_ui()
    _apply_theme()
    _refresh_swatches()
    _update_previews()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.name = "Background"
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    bg.color = NAVY_BG
    add_child(bg)

    var root := MarginContainer.new()
    root.name = "MarginContainer"
    root.set_anchors_preset(Control.PRESET_FULL_RECT)
    root.offset_left = 50
    root.offset_top = 42
    root.offset_right = -50
    root.offset_bottom = -42
    add_child(root)

    var vbox := VBoxContainer.new()
    vbox.name = "VBoxContainer"
    vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    vbox.theme_override_constants/separation = 20
    root.add_child(vbox)

    title_label = Label.new()
    title_label.name = "TitleLabel"
    title_label.text = "PLAYER COLORS"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 52)
    title_label.add_theme_color_override("font_color", TEXT_LIGHT)
    vbox.add_child(title_label)

    mode_label = Label.new()
    mode_label.name = "ModeLabel"
    mode_label.text = "SOLO" if Global.game_mode == "solo" else "LOCAL MULTIPLAYER"
    mode_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    mode_label.add_theme_font_size_override("font_size", 24)
    mode_label.add_theme_color_override("font_color", Color("#B8D9FF"))
    vbox.add_child(mode_label)

    var selectors := HBoxContainer.new()
    selectors.alignment = BoxContainer.ALIGNMENT_CENTER
    selectors.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    selectors.custom_minimum_size = Vector2(0, 240)
    vbox.add_child(selectors)

    p1_box = VBoxContainer.new()
    p1_box.alignment = BoxContainer.ALIGNMENT_CENTER
    p1_box.custom_minimum_size = Vector2(420, 200)
    selectors.add_child(p1_box)

    var p1_label := Label.new()
    p1_label.text = "PLAYER 1"
    p1_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    p1_label.add_theme_font_size_override("font_size", 22)
    p1_label.add_theme_color_override("font_color", TEXT_LIGHT)
    p1_box.add_child(p1_label)

    var p1_panel := Panel.new()
    p1_panel.custom_minimum_size = Vector2(220, 110)
    p1_panel.modulate = PANEL_BG
    p1_box.add_child(p1_panel)

    preview_p1 = ColorRect.new()
    preview_p1.set_anchors_preset(Control.PRESET_FULL_RECT)
    preview_p1.offset_left = 18
    preview_p1.offset_top = 18
    preview_p1.offset_right = -18
    preview_p1.offset_bottom = -18
    preview_p1.color = Global.player_1_color
    p1_panel.add_child(preview_p1)

    p2_box = VBoxContainer.new()
    p2_box.alignment = BoxContainer.ALIGNMENT_CENTER
    p2_box.custom_minimum_size = Vector2(420, 200)
    selectors.add_child(p2_box)

    var p2_label := Label.new()
    p2_label.text = "PLAYER 2"
    p2_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    p2_label.add_theme_font_size_override("font_size", 22)
    p2_label.add_theme_color_override("font_color", TEXT_LIGHT)
    p2_box.add_child(p2_label)

    var p2_panel := Panel.new()
    p2_panel.custom_minimum_size = Vector2(220, 110)
    p2_panel.modulate = PANEL_BG
    p2_box.add_child(p2_panel)

    preview_p2 = ColorRect.new()
    preview_p2.set_anchors_preset(Control.PRESET_FULL_RECT)
    preview_p2.offset_left = 18
    preview_p2.offset_top = 18
    preview_p2.offset_right = -18
    preview_p2.offset_bottom = -18
    preview_p2.color = Global.player_2_color
    p2_panel.add_child(preview_p2)

    if Global.game_mode == "solo":
        p2_box.visible = false
    else:
        p2_box.visible = true

    swatch_grid = GridContainer.new()
    swatch_grid.columns = 7
    swatch_grid.theme_override_constants/h_separation = 12
    swatch_grid.theme_override_constants/v_separation = 12
    swatch_grid.alignment = BoxContainer.ALIGNMENT_CENTER
    vbox.add_child(swatch_grid)

    start_button = Button.new()
    start_button.text = "START"
    start_button.custom_minimum_size = Vector2(220, 52)
    start_button.pressed.connect(_on_start_pressed)
    vbox.add_child(start_button)

    back_button = Button.new()
    back_button.text = "BACK"
    back_button.custom_minimum_size = Vector2(220, 52)
    back_button.pressed.connect(_on_back_pressed)
    vbox.add_child(back_button)

    for color_index in range(Global.get_palette_colors().size()):
        var swatch_button := Button.new()
        swatch_button.toggle_mode = true
        swatch_button.focus_mode = Control.FOCUS_NONE
        swatch_button.custom_minimum_size = Vector2(70, 58)
        swatch_button.modulate = Global.get_palette_colors()[color_index]
        swatch_button.text = ""
        swatch_button.set_meta("color", Global.get_palette_colors()[color_index])
        swatch_button.pressed.connect(_on_swatch_pressed.bind(Global.get_palette_colors()[color_index]))
        swatch_grid.add_child(swatch_button)

    if Global.game_mode == "solo":
        p1_color = Global.selected_solo_color
        p2_color = Global.selected_solo_color

func _apply_theme() -> void:
    title_label.add_theme_color_override("font_color", TEXT_LIGHT)
    start_button.modulate = BUTTON_BG
    back_button.modulate = BUTTON_BG
    start_button.add_theme_color_override("font_color", TEXT_LIGHT)
    back_button.add_theme_color_override("font_color", TEXT_LIGHT)
    start_button.add_theme_font_size_override("font_size", 22)
    back_button.add_theme_font_size_override("font_size", 22)

func _on_swatch_pressed(color: Color) -> void:
    if Global.game_mode == "solo":
        Global.selected_solo_color = color
        p1_color = color
        _refresh_swatches()
        _update_previews()
        return

    if current_player == 1:
        p1_color = color
    else:
        p2_color = color
    _refresh_swatches()
    _update_previews()

func _refresh_swatches() -> void:
    for child in swatch_grid.get_children():
        if child is Button:
            var swatch_color: Color = child.get_meta("color")
            var selected_color: Color = p1_color if current_player == 1 else p2_color
            var other_color: Color = p2_color if current_player == 1 else p1_color
            child.button_pressed = Global.color_matches(swatch_color, selected_color)
            child.disabled = (Global.color_matches(swatch_color, other_color) and not Global.color_matches(swatch_color, selected_color))
            child.modulate = swatch_color

func _update_previews() -> void:
    preview_p1.color = p1_color
    preview_p2.color = p2_color

func _on_start_pressed() -> void:
    if Global.game_mode == "solo":
        if not Global.is_valid_player_color(p1_color):
            return
        Global.selected_solo_color = p1_color
        get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
        return

    if p1_color == p2_color:
        return

    Global.player_1_color = p1_color
    Global.player_2_color = p2_color
    get_tree().change_scene_to_file("res://Scenes/Arena.tscn")

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
