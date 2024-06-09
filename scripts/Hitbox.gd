class_name Hitbox
extends Area2D


var DAMAGE := 3


func _init() -> void:
	# The collision layer is 2, collision mask is 0
	collision_layer = 2
	collision_mask = 0
