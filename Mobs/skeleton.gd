extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var speed = 100
@onready var anim = $AnimatedSprite2D
var alife = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized() 
	if alife == true:
		if chase == true:
			velocity.x = direction.x * speed 
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("Idle")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	move_and_slide()


func _on_detect_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detect_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false 


func _on_deth_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y -= 300 
		deth()
		
func _on_deth_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if alife == true:
			body.health -=40
			deth()
		
func deth():
	alife = false
	anim.play("Deth")
	await anim.animation_finished
	queue_free()
