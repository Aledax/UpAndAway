extends Node2D

@export var texts : Dictionary
var area_2d

func _ready():
	area_2d = $Area2D
	if area_2d.texts == null:
		area_2d.set_texts(texts)

func set_texts(given_texts):
	area_2d.set_texts(given_texts)

func set_npc_name(given_name):
	area_2d.set_npc_name(given_name)

func set_dialogue(dialogue_key):
	area_2d.set_dialogue(dialogue_key)
	
func set_desired_item(desired_item):
	area_2d.set_desired_item(desired_item)
