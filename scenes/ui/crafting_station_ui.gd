extends PanelContainer

@onready var list_collection: VBoxContainer = $MarginContainer/VBoxContainer/HBoxBodyContainer/RecipesPanel/ScrollContainer/ListCollection
@onready var result_item_recipe: Label = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/ResultItemRecipe
@onready var main_icon_item_selected: TextureRect = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/ItemIcomPanelContainer/VBoxContainer/MarginContainer/MainIconItemSelected
@onready var result_item_quantity_label: Label = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/ItemIcomPanelContainer/VBoxContainer/ResultItemQuantityLabel
@onready var ingredients_list: VBoxContainer = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/IngredientsList
@onready var quantity_to_produce_label: Label = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/HBoxContainer/QuantityToProduceLabel
@onready var more_item_button: Button = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/HBoxContainer/MoreItemButton
@onready var less_item_button: Button = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/HBoxContainer/LessItemButton
@onready var create_button: Button = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/CreateButton


var units_product: int = 1
var items_database = ItemsDataBase.new()
var current_selected_item: ItemData = null

var _crafting_station: CraftigStation

const recipe_item_result_scene: PackedScene = preload("res://scenes/ui/work_station_item_list.tscn")
const recipe_item_ingredient_scene: PackedScene = preload("res://scenes/ui/line_item_ingredient.tscn")

func _ready() -> void:
	var items: Array[ItemData] = items_database.get_all_crafting_station_items_data()
	
	for item: ItemData in items:
		var item_to_create: Button = recipe_item_result_scene.instantiate()
		item_to_create.text = item.display_name
		item_to_create.icon = item.icon
		item_to_create.pressed.connect(_on_item_list_button_pressed.bind(item))
		list_collection.add_child(item_to_create)
	
	_on_item_list_button_pressed(items[0])


func _clear_ingredients_list_nodes() -> void:
	for child_node: Node in ingredients_list.get_children():
		child_node.queue_free()


func _on_item_list_button_pressed(item: ItemData) -> void:
	current_selected_item = item
	units_product = 1
	quantity_to_produce_label.text = str(units_product)
	result_item_quantity_label.text = str(item.items_produced)
	#inventory_quantity = 0
	
	_clear_ingredients_list_nodes()
	
	result_item_recipe.text = current_selected_item.display_name
	main_icon_item_selected.texture = item.icon
	_add_ingredients_to_list_display(current_selected_item)
	_update_result_quntity_display()
	#_update_create_button_state()


func _update_ingredient_quantities_display() -> void:
	for ingredient_line_node: Node in ingredients_list.get_children():
		var quantity_text_label: Label = ingredient_line_node.get_node("ItemIngredientQuantity")
		var base_quantity: int = ingredient_line_node.get_meta("ingredient_base_quantity")
		var ingredient_id_meta: StringName = ingredient_line_node.get_meta("ingredient_id")
		
		var current_inventory_quantity: int = get_item_quantity_in_inventory(ingredient_id_meta)
		var needed_quantity: int = base_quantity * units_product
		#inventory_quantity = get_item_quantity_in_inventory(ingredient_id_meta)
		
		#quantity_text_label.text = str(inventory_quantity) + "/" + ingredients_necessary_to_produce(base_quantity)
		quantity_text_label.text = "%s/%s" % [current_inventory_quantity, needed_quantity]
		if current_inventory_quantity < needed_quantity:
			quantity_text_label.modulate = Color.RED
		else:
			quantity_text_label.modulate = Color.GREEN


func _update_result_quntity_display() -> void:
	result_item_quantity_label.text = str(units_product * current_selected_item.items_produced)


func _add_ingredients_to_list_display(item: ItemData) -> void:
	for ingredient: Ingredient in item.crafting_ingredients:
		var inventory_has = get_item_quantity_in_inventory(ingredient.id)
		
		var ingredient_line_instance: HBoxContainer = recipe_item_ingredient_scene.instantiate()
		var ingredient_item_info: ItemData = items_database.get_item_data(ingredient.id)
		
		ingredient_line_instance.get_node("ItemIngredientTexture").texture = ingredient_item_info.icon
		ingredient_line_instance.get_node("ItemIngredientName").text = ingredient_item_info.display_name
		ingredient_line_instance.get_node("ItemIngredientQuantity").text = "%s/%s" % [inventory_has, ingredients_necessary_to_produce(ingredient.quantity)]
		
		ingredient_line_instance.set_meta("ingredient_base_quantity", ingredient.quantity)
		ingredient_line_instance.set_meta("ingredient_id", ingredient.id)
		
		ingredients_list.add_child(ingredient_line_instance)


func setup_crafting_station(crafting_station_scene: CraftigStation) -> void:
	_crafting_station = crafting_station_scene


func get_item_quantity_in_inventory(id: StringName) -> int:
	return InventoryManager.get_item_quantity(id)


func ingredients_necessary_to_produce(ingredient_units_base: int) -> String:
	return str(ingredient_units_base * units_product)


func _can_craft_item() -> bool:
	if units_product <= 0:
		return false

	for ingredient: Ingredient in current_selected_item.crafting_ingredients:
		var needed: int = ingredient.quantity * units_product
		if get_item_quantity_in_inventory(ingredient.id) < needed:
			return false

	return true


func _update_create_button_state() -> void:
	create_button.disabled = not _can_craft_item()


func _on_less_item_button_pressed() -> void:
	if units_product > 1:
		units_product -= 1
	
	quantity_to_produce_label.text = str(units_product)
	_update_ingredient_quantities_display()
	_update_result_quntity_display()
	_update_create_button_state()


func _on_more_item_button_pressed() -> void:
	units_product += 1
	quantity_to_produce_label.text = str(units_product)
	_update_ingredient_quantities_display()
	_update_result_quntity_display()
	_update_create_button_state()

func _on_create_button_pressed() -> void:
	if not _can_craft_item():
		return
	
	for ingredient: Ingredient in current_selected_item.crafting_ingredients:
		var quantity_to_remove = ingredient.quantity * units_product
		InventoryManager.remove_item(ingredient.id, quantity_to_remove)
		print(quantity_to_remove)
		
	_crafting_station.init_craft(current_selected_item, units_product)
	_update_ingredient_quantities_display()
	_update_create_button_state()
	queue_free()


func _on_close_work_station_pressed() -> void:
	queue_free()
