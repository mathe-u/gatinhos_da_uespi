class_name HurtComponent2
extends Area2D

signal hurt

func _on_area_entered(area: Area2D) -> void:
	var hit_component: HitComponent = area as HitComponent
	
	hurt.emit(hit_component.hit_damage)
	
	if hit_component.get_parent() is Projectile:
		hit_component.get_parent().remove_projectile()
