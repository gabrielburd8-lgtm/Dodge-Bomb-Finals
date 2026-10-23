extends Node2D

const PLAYER_SCENE := preload("res://Scenes/Player.tscn")
const BOMB_SCENE := preload("res://Scenes/Bomb.tscn")
const PICKUP_SCENE := preload("res://Scenes/Pickup.tscn")

const ARENA_MIN := Vector2(60, 60)
const ARENA_MAX := Vector2(1860, 1020)

var players: Array = []
var bombs: Array = []
var pickups: Array = []
var match_timer: float = 0.0
var start_delay: float = 3.0
var game_over: bool = false
var bomb_spawn_timer: float = 0.0
var pickup_spawn_timer: float = 0.0
var bomb_spawn_interval: float = 2.2

var hud_layer: CanvasLayer
var hud_root: Control
var timer_label: Label
var status_label: Label
var p1_status: Label
var p2_status: Label

func _ready() -> void:
    _build_hud()
    _spawn_players()
    _create_obstacles()
    _spawn_pickup()
    _update_hud()

func _process(delta: float) -> void:
    if game_over:
        return

    if start_delay > 0.0:
        start_delay -= delta
        timer_label.text = "START %d" % ceil(start_delay)
        return

    match_timer += delta
    bomb_spawn_timer -= delta
    pickup_spawn_timer -= delta

    if bomb_spawn_timer <= 0.0:
        _spawn_bomb()
        bomb_spawn_timer = max(0.7, bomb_spawn_interval - (match_timer * 0.08))

    if pickup_spawn_timer <= 0.0:
        _spawn_pickup()
        pickup_spawn_timer = 9.0

    _update_hud()

func _build_hud() -> void:
    hud_layer = CanvasLayer.new()
    add_child(hud_layer)

    hud_root = Control.new()
    hud_root.set_anchors_preset(Control.PRESET_FULL_RECT)
    hud_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    hud_layer.add_child(hud_root)

    timer_label = Label.new()
    timer_label.anchor_left = 0.5
    timer_label.anchor_right = 0.5
    timer_label.position = Vector2(-160, 20)
    timer_label.size = Vector2(320, 60)
    timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    timer_label.add_theme_font_size_override("font_size", 30)
    hud_root.add_child(timer_label)

    status_label = Label.new()
    status_label.anchor_left = 0.5
    status_label.anchor_right = 0.5
    status_label.position = Vector2(-220, 70)
    status_label.size = Vector2(440, 40)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 18)
    hud_root.add_child(status_label)

    p1_status = Label.new()
    p1_status.position = Vector2(40, 40)
    p1_status.size = Vector2(280, 30)
    p1_status.add_theme_font_size_override("font_size", 18)
    hud_root.add_child(p1_status)

    p2_status = Label.new()
    p2_status.position = Vector2(40, 80)
    p2_status.size = Vector2(280, 30)
    p2_status.add_theme_font_size_override("font_size", 18)
    hud_root.add_child(p2_status)

func _spawn_players() -> void:
    var p1 = PLAYER_SCENE.instantiate()
    p1.position = Vector2(420, 540)
    p1.configure("Player 1", "p1", Global.player_1_color)
    add_child(p1)
    players.append(p1)

    if Global.game_mode == "versus":
        var p2 = PLAYER_SCENE.instantiate()
        p2.position = Vector2(1480, 540)
        p2.configure("Player 2", "p2", Global.player_2_color)
        add_child(p2)
        players.append(p2)

func _create_obstacles() -> void:
    var obstacle_positions := [
        Vector2(480, 250),
        Vector2(760, 700),
        Vector2(1180, 300),
        Vector2(1490, 740)
    ]
    var obstacle_sizes := [
        Vector2(180, 40),
        Vector2(220, 42),
        Vector2(180, 42),
        Vector2(210, 42)
    ]

    for index in range(obstacle_positions.size()):
        var body := StaticBody2D.new()
        body.position = obstacle_positions[index]
        var shape := CollisionShape2D.new()
        var rect := RectangleShape2D.new()
        rect.size = obstacle_sizes[index]
        shape.shape = rect
        body.add_child(shape)

        var sprite := Sprite2D.new()
        sprite.texture = preload("res://icon.svg")
        sprite.scale = Vector2(obstacle_sizes[index].x / 90.0, obstacle_sizes[index].y / 90.0)
        sprite.modulate = Color("#4A5568")
        body.add_child(sprite)
        add_child(body)

func _spawn_bomb() -> void:
    if bombs.size() >= 7:
        return

    var bomb := BOMB_SCENE.instantiate()
    bomb.position = _random_valid_position()
    bomb.blast_radius = 220.0
    bomb.impulse_strength = 500.0
    add_child(bomb)
    bombs.append(bomb)
    bomb.exploded.connect(_on_bomb_exploded)

func _spawn_pickup() -> void:
    if pickups.size() >= 3:
        return

    var pickup := PICKUP_SCENE.instantiate()
    pickup.position = _random_valid_position()
    pickup.set_kind(randi() % 2 == 0 ? "speed" : "shield")
    add_child(pickup)
    pickups.append(pickup)
    pickup.collected.connect(_on_pickup_collected)

func _random_valid_position() -> Vector2:
    for i in range(200):
        var candidate := Vector2(randf_range(ARENA_MIN.x, ARENA_MAX.x), randf_range(ARENA_MIN.y, ARENA_MAX.y))
        var blocked := false
        for player in players:
            if player.global_position.distance_to(candidate) < 120.0:
                blocked = true
        if blocked:
            continue
        return candidate
    return Vector2(960, 540)

func _on_bomb_exploded(bomb: Node) -> void:
    if not bombs.has(bomb):
        return

    var bomb_index := bombs.find(bomb)
    if bomb_index >= 0:
        bombs.remove_at(bomb_index)

    for player in players:
        if not player.is_alive:
            continue
        var distance := player.global_position.distance_to(bomb.global_position)
        if distance < bomb.blast_radius:
            var direction := (player.global_position - bomb.global_position).normalized()
            player.apply_explosion_knockback(direction, (1.0 - distance / bomb.blast_radius) * 800.0)
            if player.has_shield():
                player.consume_shield()
            else:
                player.eliminate()

    for other in bombs:
        if other == bomb:
            continue
        var distance := other.global_position.distance_to(bomb.global_position)
        if distance < bomb.blast_radius:
            var direction := (other.global_position - bomb.global_position).normalized()
            other.apply_central_impulse(direction * 800.0)

    _check_game_result()

func _on_pickup_collected(kind: String, pickup: Node) -> void:
    if pickups.has(pickup):
        pickups.erase(pickup)
    for player in players:
        if player.is_alive:
            player.apply_pickup(kind)

func _check_game_result() -> void:
    if game_over:
        return

    var alive_players := []
    for player in players:
        if player.is_alive:
            alive_players.append(player)

    if Global.game_mode == "solo":
        if alive_players.is_empty():
            _show_results("You Were Eliminated!", ["Retry", "Main Menu"])
            game_over = true
    else:
        if alive_players.size() == 0:
            _show_results("Draw!", ["Retry", "Main Menu"])
            game_over = true
        elif alive_players.size() == 1:
            _show_results(alive_players[0].player_name + " Wins!", ["Retry", "Main Menu"])
            game_over = true

func _show_results(title: String, actions: Array) -> void:
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
    timer_label.text = "%02d:%02d" % [seconds / 60, seconds % 60]

    if Global.game_mode == "solo":
        status_label.text = "Solo Survival"
        p1_status.text = "Player 1: " + (players[0].is_alive ? "Alive" : "Eliminated")
    else:
        status_label.text = "2-Player Local"
        if players.size() >= 2:
            p1_status.text = "Player 1: " + (players[0].is_alive ? "Alive" : "Eliminated")
            p2_status.text = "Player 2: " + (players[1].is_alive ? "Alive" : "Eliminated")

func _on_retry_pressed() -> void:
    get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
