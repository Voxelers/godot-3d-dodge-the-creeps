extends KinematicBody

export var speed = 18

var velocity = Vector3.ZERO

# Move the bullet outside the player
var fire_gap = 1

# Called when the node enters the scene tree for the first time.
# func _ready():
#	velocity = Vector3.FORWARD * speed

func initialize(start_position, start_rotation):
	
	# Fire the bullet from outside the player to avid collisions
	if start_rotation.y == 0:
		start_position.z = start_position.z - fire_gap
	elif int(start_rotation.y) == int(PI/2):
		start_position.x = start_position.x - fire_gap
	elif int(start_rotation.y) == int(-PI/2):
		start_position.x = start_position.x + fire_gap
	elif int(start_rotation.y) == int(PI):
		start_position.z = start_position.z + fire_gap
				
	translate(start_position)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, start_rotation.y)
	
func _physics_process(_delta):
	move_and_slide(velocity)

func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _on_Mob_Detector_body_entered(mob):
	print("The bullet hit a mob")
	mob.hit_by_bullet()
	queue_free()
