extends CharacterBody2D


var speed = 100

# Target character
var target: CharacterBody2D = null


@onready var animated_sprite = $AnimatedSprite2D

# Function called every frame
func _process(delta):
	# Update the target every frame
	update_target()
	if target != null:
		# Calculate the direction towards the target
		var direction = (target.global_position - global_position).normalized()
		# Move the character towards the target
		velocity = direction * speed
		move_and_slide()

		# Update animation and flip
		animated_sprite.play("walk")
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
	else:
		# If no target is defined, the character remains stationary
		velocity = Vector2.ZERO
		animated_sprite.play("idle")

# Function to find the nearest character
func find_nearest_target():
	var nearest_target = null
	var nearest_distance = INF
	for body in get_tree().get_nodes_in_group("characters"):
		if body != self and body is CharacterBody2D:
			var distance = global_position.distance_to(body.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_target = body
	return nearest_target

# Update the target every frame
func update_target():
	target = find_nearest_target()

# Function called when the script is added to the scene
func _ready():
	# Add this character to the "characters" group
	add_to_group("characters")
	# Ensure the idle animation is playing initially
	animated_sprite.play("idle")
