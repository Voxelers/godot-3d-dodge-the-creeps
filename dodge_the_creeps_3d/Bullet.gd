extends KinematicBody

export var speed = 18

var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
# func _ready():
#	velocity = Vector3.FORWARD * speed

func initialize(start_position, start_rotation):
	translate(start_position)
	# rotate(Vector3.UP, start_rotation.y)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, start_rotation.y)
	# velocity = transform.basis.z.normalized() * speed
	
func _physics_process(_delta):
	move_and_slide(velocity)
