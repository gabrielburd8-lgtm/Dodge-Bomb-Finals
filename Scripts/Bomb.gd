extends CharacterBody2D

const BASE_SPEED := 220.0
const DASH_SPEED := 560.0
const ACCELERATION := 1800.0
const FRICTION := 1400.0
const SHIELD_DURATION := 10.0

var input_prefix: String = "input_p1"
var player_name: String = "Player 1"
var is_alive: bool = true
var ability_kind: String = "none"
var ability_inventory: String = "none"
var dash_timer: float = 0.0
var dash_cooldown: float = 0.0
var shield_timer: float = 0.0
var shield_cooldown: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Sprite2D
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var name_label: Label = $NameLabel

func _ready() -> void:
    if sprite != null:
        sprite.modulate = Color("#1677FF")
    if shield_sprite != null:
        shield_sprite.visible = false
    if name_label != null:
        name_label.text = player_name

func configure(name_value: String, prefix: String, color: Color) -> void:
    player_name = name_value
    input_prefix = "input_" + prefix
    ability_kind = Global.get_ability_for_color(color)
    ability_inventory = ability_kind
    if sprite != null:
        sprite.modulate = color
    if shield_sprite != null:
        shield_sprite.modulate = color
    if name_label != null:
        name_label.text = player_name

func _physics_process(delta: float) -> void:
    if not is_alive:
        return

    if dash_timer > 0.0:
        dash_timer = max(0.0, dash_timer - delta)
    if dash_cooldown > 0.0:
        dash_cooldown = max(0.0, dash_cooldown - delta)
    if shield_timer > 0.0:
        shield_timer = max(0.0, shield_timer - delta)
        if shield_timer <= 0.0 and shield_sprite != null:
            shield_sprite.visible = false
    if shield_cooldown > 0.0:
        shield_cooldown = max(0.0, shield_cooldown - delta)

    var direction := Vector2.ZERO
    direction.x = float(Input.is_action_pressed(input_prefix + "_right")) - float(Input.is_action_pressed(input_prefix + "_left"))
    direction.y = float(Input.is_action_pressed(input_prefix + "_down")) - float(Input.is_action_pressed(input_prefix + "_up"))
    if direction.length() > 1.0:
        direction = direction.normalized()
    if direction != Vector2.ZERO:
        last_direction = direction

    if dash_timer > 0.0:
        velocity = last_direction.normalized() * DASH_SPEED
    else:
        var target_velocity := direction * BASE_SPEED
        if direction == Vector2.ZERO:
            velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
        else:
            velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)

    move_and_slide()
    position.x = clamp(position.x, 90.0, 1190.0)
    position.y = clamp(position.y, 90.0, 630.0)

func collect_pickup(kind: String) -> void:
    if ability_kind == "none":
        return
    if kind == ability_kind and ability_inventory == "none":
        ability_inventory = kind

func use_ability() -> void:
    if not is_alive:
        return

    if ability_inventory == "dash":
        if dash_cooldown > 0.0:
            return
        dash_timer = 0.18
        dash_cooldown = 1.2
        velocity = last_direction.normalized() * DASH_SPEED
        return

    if ability_inventory == "shield":
        if shield_cooldown > 0.0 or shield_timer > 0.0:
            return
        shield_timer = SHIELD_DURATION
        shield_cooldown = 3.0
        if shield_sprite != null:
            shield_sprite.visible = true

func has_shield() -> bool:
    return shield_timer > 0.0 and is_alive

func consume_shield() -> void:
    shield_timer = 0.0
    if shield_sprite != null:
        shield_sprite.visible = false

func apply_explosion_knockback(direction: Vector2, force: float) -> void:
    velocity += direction * force * 0.06

func eliminate() -> void:
    if not is_alive:
        return
    is_alive = false
    visible = false
    velocity = Vector2.ZERO
    if shield_sprite != null:
        shield_sprite.visible = false

func reset_state() -> void:
    is_alive = true
    visible = true
    dash_timer = 0.0
    dash_cooldown = 0.0
    shield_timer = 0.0
    shield_cooldown = 0.0
    ability_inventory = ability_kind
    if shield_sprite != null:
        shield_sprite.visible = false
