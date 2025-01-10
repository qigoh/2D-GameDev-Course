extends Sprite2D

var velocity := Vector2(0,0)
var max_speed := 600.0
var boost_speed := 1500.0
var steering_factor := 10.0
var canBoost := true
#@onready var boostTime : Timer = %BoostTime

func _process(delta: float) -> void:
	var direction := Vector2(0,0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	#var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if (direction.length() > 1.0):
		direction = direction.normalized()
	if (Input.is_action_just_pressed("boost") and canBoost):
		canBoost = false
		max_speed = boost_speed
		get_node("BoostTime").start()
	var desired_velocity = direction * max_speed
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * delta * steering_factor
	#velocity = velocity.lerp(desired_velocity, steering_factor * delta)
	position += velocity * delta
	if direction.length() > 0.0:
		rotation = velocity.angle()
	pass

func _on_timer_timeout() -> void:
	max_speed = 600.0
	get_node("BoostCooldown").start()
	
func _on_boost_cooldown_timeout() -> void:
	canBoost = true
