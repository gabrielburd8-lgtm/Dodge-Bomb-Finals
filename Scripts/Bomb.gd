extends CharacterBody2D

const MAX_SPEED := 260.0
const BOOST_MULTIPLIER := 1.7
const ACCELERATION := 1600.0
const FRICTION := 1800.0

var input_prefix: String = "input_p1"
var player_name: String = "Player 1"
var is_alive: bool = true
var speed_boost_timer: float = 0.0
var shield_timer: float = 0.0
var shield_active: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var shield_sprite: Sprite2D = $ShieldSprite

func _ready() -> void:
    add_to_group("players")
    shield_sprite.visible = false
    sprite.modulate = Color("#1677FF")

func configure(name_value: String, prefix: String, color: Color) -> void:
    player_name = name_value
    input_prefix = "input_" + prefix
    sprite.modulate = color
    shield_sprite.modulate = color

func _physics_process(delta: float) -> void:
    if not is_alive:
        return

    if speed_boost_timer > 0.0:
        speed_boost_timer = max(0.0, speed_boost_timer - delta)
    if shield_timer > 0.0:
        shield_timer = max(0.0, shield_timer - delta)
        if shield_timer <= 0.0:
            shield_active = false
            shield_sprite.visible = false

    var direction := Vector2.ZERO
    direction.x = (1 if Input.is_action_pressed(input_prefix + "_right") else 0) - (1 if Input.is_action_pressed(input_prefix + "_left") else 0)
    direction.y = (1 if Input.is_action_pressed(input_prefix + "_down") else 0) - (1 if Input.is_action_pressed(input_prefix + "_up") else 0)
    if direction.length() > 1.0:
        direction = direction.normalized()

    var current_speed := MAX_SPEED
    if speed_boost_timer > 0.0:
        current_speed *= BOOST_MULTIPLIER

    var target_velocity := direction * current_speed
    if direction == Vector2.ZERO:
        velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
    else:
        velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)

    move_and_slide()
    position.x = clamp(position.x, 80.0, 1840.0)
    position.y = clamp(position.y, 80.0, 1000.0)

    if Input.is_action_just_pressed(input_prefix + "_ability"):
        use_ability()

func apply_explosion_knockback(direction: Vector2, force: float) -> void:
    velocity += direction * (force / 10.0)

func use_ability() -> void:
    if shield_active and shield_timer > 0.0:
        return

    if speed_boost_timer > 0.0:
        shield_active = true
        shield_timer = 1.5
        shield_sprite.visible = true
        return

    speed_boost_timer = 4.0

func has_shield() -> bool:
    return shield_active and shield_timer > 0.0

func consume_shield() -> void:
    shield_active = false
    shield_timer = 0.0
    shield_sprite.visible = false

func apply_pickup(kind: String) -> void:
    if kind == "speed":
        speed_boost_timer = 4.0
    elif kind == "shield":
        shield_active = true
        shield_timer = 6.0
        shield_sprite.visible = true

func eliminate() -> void:
    is_alive = false
    visible = false
