extends Area2D

signal exploded(bomb: Node)

var countdown: float = 2.6
var blast_radius: float = 200.0
var active: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var countdown_label: Label = $CountdownLabel

func _ready() -> void:
    sprite.modulate = Color("#FFB703")
    countdown_label.text = "%0.1f" % countdown
    countdown_label.add_theme_color_override("font_color", Color("#FFFFFF"))
    countdown_label.add_theme_font_size_override("font_size", 20)

func _process(delta: float) -> void:
    if not active:
        return

    countdown = max(0.0, countdown - delta)
    countdown_label.text = "%0.1f" % countdown

    if countdown <= 0.25:
        sprite.scale = Vector2(1.22, 1.22)
        sprite.modulate = Color("#FF5A36")
    elif countdown <= 1.0:
        sprite.scale = Vector2(1.08, 1.08)
        sprite.modulate = Color("#FF8A00")
    else:
        sprite.scale = Vector2(1.0, 1.0)
        sprite.modulate = Color("#FFB703")

    if countdown <= 0.0:
        explode()

func explode() -> void:
    if not active:
        return
    active = false
    exploded.emit(self)
    queue_free()
