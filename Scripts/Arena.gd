extends Area2D

signal collected(kind: String, pickup: Node)

var kind: String = "dash"
var pulse_phase: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    _apply_visuals()

func _process(delta: float) -> void:
    pulse_phase += delta * 3.0
    var glow := 0.8 + sin(pulse_phase) * 0.2
    if sprite != null:
        sprite.scale = Vector2(1.15 + sin(pulse_phase) * 0.15, 1.15 + sin(pulse_phase) * 0.15)
        sprite.modulate = Color(1.0, 1.0, 1.0, glow)

func set_kind(value: String) -> void:
    kind = value
    _apply_visuals()

func _apply_visuals() -> void:
    if kind == "dash":
        sprite.modulate = Color("#FF3B30")
        if label != null:
            label.text = "DASH"
            label.add_theme_color_override("font_color", Color("#FFFFFF"))
    else:
        sprite.modulate = Color("#1677FF")
        if label != null:
            label.text = "SHIELD"
            label.add_theme_color_override("font_color", Color("#FFFFFF"))

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("players"):
        if body.has_method("collect_pickup"):
            body.collect_pickup(kind)
        collected.emit(kind, self)
        queue_free()
