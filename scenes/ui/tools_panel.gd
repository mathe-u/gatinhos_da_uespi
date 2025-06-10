extends PanelContainer

var shortcut_buttons: Array[Button] = []
var shortcut_tools: Array[DataTypes.Tools] = [
	DataTypes.Tools.AxeWood,
	DataTypes.Tools.GunBlaster,
	DataTypes.Tools.Torch,
	DataTypes.Tools.None,
	DataTypes.Tools.None,
]

var current_focus_index: int = -1

func _ready() -> void:
	var hbox: HBoxContainer = $MarginContainer/HBoxContainer
	
	for i: int in range(hbox.get_child_count()):
		var shortcut_node: PanelContainer = hbox.get_child(i)
		
		if shortcut_node.has_node("ShortcutButton"):
			var button: Button = shortcut_node.get_node("ShortcutButton")
			
			shortcut_buttons.append(button)
			button.focus_mode = Control.FOCUS_ALL
			
			button.focus_neighbor_left = button.get_path()
			button.focus_neighbor_right = button.get_path()
			button.focus_neighbor_top = button.get_path()
			button.focus_neighbor_bottom = button.get_path()
			
			button.focus_entered.connect(_on_shortcut_focus_entered.bind(i))
			button.pressed.connect(_on_shortcut_pressed.bind(i))


func _on_shortcut_focus_entered(index: int) -> void:
	current_focus_index = index
	ToolManager.select_tool(shortcut_tools[index])


func _on_shortcut_pressed(index: int) -> void:
	ToolManager.select_tool(shortcut_tools[index])


#func _gui_input(event: InputEvent) -> void:
	#if event.is_action("ui_up") or \
	   #event.is_action("ui_down") or \
	   #event.is_action("ui_left") or \
	   #event.is_action("ui_right"):
		#accept_event()


func _unhandled_input(event: InputEvent) -> void:
	for i: int in range(1, shortcut_buttons.size() + 1):
		var action_name: String = "%d_hotbar_slot" % i
		if event.is_action_pressed(action_name):
			var button_index = i - 1
			shortcut_buttons[button_index].grab_focus()
			return
	
	if event.is_action_pressed("hotbar_next"):
		if current_focus_index == -1:
			current_focus_index = 0
		else:
			current_focus_index = (current_focus_index + 1) % shortcut_buttons.size()
		
		shortcut_buttons[current_focus_index].grab_focus()
	
	elif event.is_action_pressed("hotbar_previous"):
		if current_focus_index == -1:
			current_focus_index = shortcut_buttons.size() - 1
		else:
			current_focus_index = (current_focus_index - 1 + shortcut_buttons.size()) % shortcut_buttons.size()
		
		shortcut_buttons[current_focus_index].grab_focus()


func release_all_focus() -> void:
	if current_focus_index != -1 and is_instance_valid(shortcut_buttons[current_focus_index]):
		shortcut_buttons[current_focus_index].release_focus()
	
	current_focus_index = -1
	ToolManager.select_tool(DataTypes.Tools.None)
