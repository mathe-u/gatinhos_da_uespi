extends PanelContainer

@export var list_i: Array[ItemComponent]

@onready var list_collection: VBoxContainer = $MarginContainer/VBoxContainer/HBoxBodyContainer/RecipesPanel/ScrollContainer/ListCollection
@onready var result_item_recipe: Label = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/ResultItemRecipe
@onready var main_icon_item_selected: TextureRect = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/ItemIcomPanelContainer/MarginContainer/MainIconItemSelected

@onready var ingredients_list: VBoxContainer = $MarginContainer/VBoxContainer/HBoxBodyContainer/ResultRecipesPanel/VBoxContainer/IngredientsList


var item_collection: Array = [
	{
		"name": "Wood",
		"id": "200",
		"icon": load("res://assets/game/Objects/icon_wood.png"),
		"ingredients": [
			{
				"id": "102",
				"quantity": 1,
			}
		],
		"quantity": 3,
	},
	{
		"name": "Coal",
		"id": "201",
		"icon": load("res://assets/game/Objects/icon_iron_bar.png"),
		"ingredients": [
			{
				"id": "102",
				"quantity": 1,
			}
		],
		"quantity": 10,
	},
	{
		"name": "Iron Bar",
		"id": "202",
		"icon": load("res://assets/game/Objects/icon_iron_bar2.png"),
		"ingredients": [
			{
				"id": "104",
				"quantity": 3,
			}
		],
		"quantity": 3,
	},
	{
		"name": "Cog",
		"id": "203",
		"icon": load("res://assets/game/Objects/cog_item.png"),
		"ingredients": [
			{
				"id": "202",
				"quantity": 1,
			},
			{
				"id": "201",
				"quantity": 10,
			},
		],
		"quantity": 3,
	},
]

const recipe_item_result_scene: PackedScene = preload("res://scenes/ui/work_station_item_list.tscn")
const recipe_item_ingredient_scene: PackedScene = preload("res://scenes/ui/line_item_ingredient.tscn")

func _ready() -> void:
	for item: Dictionary in item_collection:
		var item_to_create: Button = recipe_item_result_scene.instantiate()
		item_to_create.text = item["name"]
		var icon_texture: Texture2D = item["icon"]
		item_to_create.icon = icon_texture
		item_to_create.pressed.connect(_on_item_list_button_pressed.bind(item))
		list_collection.add_child(item_to_create)
	
	var defualt_item: Dictionary = item_collection[0]
	
	result_item_recipe.text = defualt_item["name"]
	main_icon_item_selected.texture = defualt_item["icon"]
	add_ingredients_to_list(defualt_item)


func _on_close_work_station_pressed() -> void:
	queue_free()

func _on_item_list_button_pressed(item: Dictionary) -> void:
	for i in ingredients_list.get_children():
		i.queue_free()
	
	result_item_recipe.text = item["name"]
	main_icon_item_selected.texture = item["icon"]
	add_ingredients_to_list(item)


func add_ingredients_to_list(item: Dictionary) -> void:
	for ingredient: Dictionary in item["ingredients"]:
		var inventory_quantity: int = get_item_quantity_in_inventory(item["id"])
		var ingredient_line_instance: HBoxContainer = recipe_item_ingredient_scene.instantiate()
		ingredient_line_instance.get_child(1).text = ingredient["id"]
		ingredient_line_instance.get_child(2).text = str(inventory_quantity) + "/" + str(ingredient["quantity"])
		ingredients_list.add_child(ingredient_line_instance)


func get_item_quantity_in_inventory(_id: String) -> int:
	return 0
