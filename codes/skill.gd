extends CollisionShape
onready var boss = get_node("/root/mundo/boss2")
func _process(delta):
	if boss.b == 1 and boss.ativo == true:
		self.disabled = true
	if boss.b == 0 and boss.ativo == true:
		self.disabled = false
	if boss.sair == 2:
		self.disabled = true
