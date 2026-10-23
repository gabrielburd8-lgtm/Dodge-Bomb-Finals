extends Area2D

signal collected(kind: String, pickup: Node)

@onready var sprite: Sprite2D = $Sprite2D

var kind: String = "speed"

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    sprite.texture = preload("res://icon.svg")
    sprite.scale = Vector2(0.16, 0.16)
    _set_palette()

func set_kind(value: String) -> void:
    kind = value
    _set_palette()

func _set_palette() -> void:
    if kind == "speed":
        sprite.modulate = Color("#32D7F5")
    else:
        sprite.modulate = Color("#34C759")

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("players"):
        collected.emit(kind, self)
        queue_free()
