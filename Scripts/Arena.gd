func _show_results(title: String, _actions: Array) -> void:
    var result_panel := Panel.new()
    result_panel.position = Vector2(540, 260)
    result_panel.size = Vector2(840, 420)
    result_panel.modulate = Color(0.1, 0.12, 0.2, 0.95)
    hud_root.add_child(result_panel)

    var result_label := Label.new()
    result_label.position = Vector2(0, 40)
    result_label.size = Vector2(840, 120)
    result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    result_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    result_label.add_theme_font_size_override("font_size", 42)
    result_label.text = title
    result_panel.add_child(result_label)

    var retry_button := Button.new()
    retry_button.position = Vector2(220, 220)
    retry_button.size = Vector2(180, 80)
    retry_button.text = "Retry"
    retry_button.pressed.connect(_on_retry_pressed)
    result_panel.add_child(retry_button)

    var menu_button := Button.new()
    menu_button.position = Vector2(440, 220)
    menu_button.size = Vector2(180, 80)
    menu_button.text = "Main Menu"
    menu_button.pressed.connect(_on_main_menu_pressed)
    result_panel.add_child(menu_button)

func _update_hud() -> void:
    var seconds := int(match_timer)
    timer_label.text = "%02d:%02d" % [int(seconds / 60.0), seconds % 60]

    if Global.game_mode == "solo":
        status_label.text = "Solo Survival"
        p1_status.text = "Player 1: " + ("Alive" if players[0].is_alive else "Eliminated")
    else:
        status_label.text = "2-Player Local"
        if players.size() >= 2:
            p1_status.text = "Player 1: " + ("Alive" if players[0].is_alive else "Eliminated")
            p2_status.text = "Player 2: " + ("Alive" if players[1].is_alive else "Eliminated")
