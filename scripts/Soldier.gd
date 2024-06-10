extends CharacterBody2D

# Movement speed of the character
var speed = 100

var attack_range = 90

# Reference to the target character
var target: CharacterBody2D = null

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var hurtbox = $AnimatedSprite2D/Hurtbox
@onready var hitbox = $AnimatedSprite2D/Hitbox

# Variable to check if the character is attacking
var is_attacking = false

# Exported variable for team
@export var equipe: int

# Points de vie du soldat
var health = 10

# Variable to check if the character is dead
var is_dead = false

# Function called every frame
func _process(delta):
	if is_dead:
		return

	# Update the target every frame
	update_target()
	if target != null:
		# Calculate the direction towards the target
		var direction = (target.global_position - global_position).normalized()
		var distance = global_position.distance_to(target.global_position)
		if distance > attack_range:
			# Move the character towards the target if not in attack range
			velocity = direction * speed
			animated_sprite.play("walk")
			move_and_slide()
			is_attacking = false
		else:
			# Attack the target if in range
			if not is_attacking:
				attack_target()
			velocity = Vector2.ZERO

		# Update sprite flip and hurtbox based on movement direction
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
			hitbox.position.x = -12
	else:
		# If no target is defined, the character remains stationary
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		is_attacking = false

# Function to find the nearest character
func find_nearest_target():
	var nearest_target = null
	var nearest_distance = INF
	for body in get_tree().get_nodes_in_group("characters"):
		if body != self and body is CharacterBody2D and body.equipe != equipe:
			var distance = global_position.distance_to(body.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_target = body
	return nearest_target

# Update the target every frame
func update_target():
	target = find_nearest_target()
	
# Function to handle death
func die():
	is_dead = true
	animated_sprite.play("death")
	animated_sprite.stop()
	await get_tree().create_timer(1).timeout
	queue_free()

# Attack the target
func attack_target():
	if target != null and is_dead == false:
		animation_player.play("attack1")
		is_attacking = true

# Function called when the script is added to the scene
func _ready():
	# Add this character to the "characters" group
	add_to_group("characters")
	# Ensure the idle animation is playing initially
	animated_sprite.play("idle")
	# Connect the animation_finished signal to the _on_AnimatedSprite2D_animation_finished function

# Collisions, Damages, ... ------------------------------------

func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount
	if health <= 0:
		die()
	else:
		animated_sprite.play("hurt")
		print("Ouch! I took ", amount, " damage")

