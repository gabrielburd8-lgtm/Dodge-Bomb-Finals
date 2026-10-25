extends RigidBody2D

signal exploded(bomb: Node)

var countdown: float = 2.5
var blast_radius: float = 220.0
var impulse_strength: float = 500.0

@onready var timer_label: Label = $CountdownLabel
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    linear_damp = 1.3
    gravity_scale = 0.0
    contact_monitor = true
    max_contacts_reported = 8
    sprite.texture = preload("res://icon.svg")
    sprite.modulate = Color("#FFA000")
    sprite.scale = Vector2(0.18, 0.18)

func _process(delta: float) -> void:
    if countdown <= 0.0:
        return
    countdown -= delta
    timer_label.text = "%0.1f" % max(countdown, 0.0)
    if countdown <= 0.0:
        explode()

func explode() -> void:
    if countdown <= 0.0:
        return
    countdown = 0.0
    exploded.emit(self)
    queue_free()
