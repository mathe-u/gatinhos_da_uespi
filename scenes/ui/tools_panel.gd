extends PanelContainer

#@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var shortcut_1: Button = $MarginContainer/HBoxContainer/Shortcut1
@onready var shortcut_2: Button = $MarginContainer/HBoxContainer/Shortcut2
@onready var shortcut_3: Button = $MarginContainer/HBoxContainer/Shortcut3
@onready var shortcut_4: Button = $MarginContainer/HBoxContainer/Shortcut4
@onready var shortcut_5: Button = $MarginContainer/HBoxContainer/Shortcut5

#@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
#@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
#@onready var tool_corn: Button = $MarginContainer/HBoxContainer/ToolCorn
#@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato



#func _on_tool_axe_pressed() -> void:
	#ToolManager.select_tool(DataTypes.Tools.AxeWood)
#
#
#func _on_tool_tilling_pressed() -> void:
	#ToolManager.select_tool(DataTypes.Tools.TillGround)
#
#
#func _on_tool_watering_can_pressed() -> void:
	#ToolManager.select_tool(DataTypes.Tools.WaterCrops)
#
#
#func _on_tool_corn_pressed() -> void:
	#ToolManager.select_tool(DataTypes.Tools.PlantCorn)
#
#
#func _on_tool_tomato_pressed() -> void:
	#ToolManager.select_tool(DataTypes.Tools.PlantTomato)



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)
		shortcut_1.release_focus()
		shortcut_2.release_focus()
		
		#tool_tilling.release_focus()
		#tool_watering_can.release_focus()
		#tool_corn.release_focus()
		#tool_tomato.release_focus()
	elif event.is_action_pressed("1_hotbar_slot"):
		shortcut_1.grab_focus()
		_on_shortcut_1_pressed()
	elif event.is_action_pressed("2_hotbar_slot"):
		shortcut_2.grab_focus()
		_on_shortcut_2_pressed()
	elif event.is_action_pressed("3_hotbar_slot"):
		shortcut_3.grab_focus()
		_on_shortcut_3_pressed()
	elif event.is_action_pressed("4_hotbar_slot"):
		shortcut_4.grab_focus()
		_on_shortcut_4_pressed()
	elif event.is_action_pressed("5_hotbar_slot"):
		shortcut_5.grab_focus()
		_on_shortcut_5_pressed()


func _on_shortcut_1_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)


func _on_shortcut_2_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.GunBlaster)


func _on_shortcut_3_pressed() -> void:
	pass


func _on_shortcut_4_pressed() -> void:
	pass # Replace with function body.


func _on_shortcut_5_pressed() -> void:
	pass # Replace with function body.
