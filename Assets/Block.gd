extends StaticBody2D

enum BlockType {BRICK, ITEM, ITEM_EMPTY, SPECIAL_ITEM}
signal on_brick_broke

export(BlockType) var block_type
export(Texture) var block_empty_image
export(Resource) var item
onready var killbox = $Enemy_Killbox


func break_block(player_is_shroomed: bool):
	if block_type == BlockType.BRICK:
		if player_is_shroomed:
			emit_signal("on_brick_broke")
			Global.add_score(50)
			queue_free()
	elif block_type == BlockType.ITEM:
		emit_signal("on_brick_broke")
		$Brick.texture = block_empty_image
		var instance = item.instance()
		add_child(instance)
		block_type = BlockType.ITEM_EMPTY
		Global.add_score(200)
		
	for enemy in killbox.get_overlapping_bodies():
		enemy.die()


func _on_Bottom_Collider_body_entered(player):
	if !player.broke_block:
		player.break_block()
		call_deferred("break_block", player.is_shroomed)
