class_name Hurtbox

extends Area2D


func _init() -> void:
	# The opposite of the Hitbox
	collision_layer = 0
	collision_mask = 2


func _ready() -> void :
	# Very important line !!! connections work this way in this version of GODOT
	connect("area_entered", self._on_area_entered)


func _on_area_entered(hitbox : Hitbox) -> void :
	if hitbox == null:
		return
		
	# Owner of the node (Hurtbox is the component of the owner node)
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.DAMAGE)
