extends Node2D

const ocean_rise_event = "_ocean_rise_event"
const npc_move_event = "_npc_move_event"
const npc_jump_event = "_npc_jump_event"
const npc_switch_dialogue_event = "_npc_switch_dialogue_event"
const collapse_event = "_collapse_event"

const kousa_beach_start = 45
const wattle_restaurant_start = 30
const sorrel_restaurant_start = 70
const sorrel_lookout_start = 140
const restaurant_collapse = 210
const wattle_launchpad_start = 250
const alder_workshop_start = 90 # 180
const alder_lookout_start = alder_workshop_start + 60 # 15 + 120
const alder_lookout_to_workshop_start = alder_lookout_start + 30 # 17 + 30
const outlook_collapse = 395

var previous_time = 0

var shader_material
var inverted_timer = 0
const inverted_duration = 0.1

func _ready():
	# Shader
	shader_material = $ColorMaskNode/ColorMask.get_material()
	shader_material.set_shader_parameter("inverted", false)
	
	# Ocean
	schedule_event("Ocean", ocean_rise_event, 150, [8])
	
	# Kousa
	schedule_event("NPCs", npc_move_event, kousa_beach_start + 0, ["kousa", -340])
	schedule_event("NPCs", npc_move_event, kousa_beach_start + 9, ["kousa", -290])
	schedule_event("NPCs", npc_move_event, kousa_beach_start + 10, ["kousa", -370])
	schedule_event("NPCs", npc_move_event, kousa_beach_start + 12, ["kousa", 0])
	schedule_event("NPCs", npc_move_event, kousa_beach_start + 17, ["kousa", -160])
	schedule_event("NPCs", npc_move_event, kousa_beach_start + 19, ["kousa", 400])
	schedule_event("NPCs", npc_jump_event, kousa_beach_start + 22.2, ["kousa", 0.1])

	# Wattle
	schedule_event("NPCs", npc_move_event, wattle_restaurant_start + 0, ["wattle", 10])
	schedule_sorrel_to_fountain(wattle_restaurant_start + 4, "wattle")
	schedule_event("NPCs", npc_move_event, wattle_restaurant_start + 28, ["wattle", 470])
	schedule_event("NPCs", npc_jump_event, wattle_restaurant_start + 31, ["wattle", 0.2])

	schedule_event("NPCs", npc_move_event, wattle_launchpad_start + 0, ["wattle", 270])
	schedule_event("NPCs", npc_jump_event, wattle_launchpad_start + 1.5, ["wattle", 0.1])
	schedule_event("NPCs", npc_move_event, wattle_launchpad_start + 3, ["wattle", 250])
	schedule_restaurant_to_elevator(wattle_launchpad_start + 4, "wattle")
	schedule_elevator_to_workshop(wattle_launchpad_start + 31, "wattle")
	schedule_workshop_to_launchpad(wattle_launchpad_start + 38, "wattle")

	# Sorrel
	schedule_event("NPCs", npc_move_event, sorrel_restaurant_start + 0, ["sorrel", 10])
	schedule_sorrel_to_fountain(sorrel_restaurant_start + 4, "sorrel")
	schedule_fountain_to_restaurant(sorrel_restaurant_start + 26.5, "sorrel")
	schedule_event("NPCs", npc_move_event, sorrel_restaurant_start + 33, ["sorrel", 440])

	schedule_event("NPCs", npc_move_event, sorrel_lookout_start + 0, ["sorrel", 250])
	schedule_restaurant_to_elevator(sorrel_lookout_start + 3, "sorrel")
	schedule_elevator_to_lookout(sorrel_lookout_start + 37, "sorrel")
	
	# Alder
	schedule_event("NPCs", npc_move_event, alder_workshop_start + 0, ["alder", 0])
	schedule_event("NPCs", npc_jump_event, alder_workshop_start + 6, ["alder", 0.2])
	schedule_elevator_to_workshop(alder_workshop_start + 6.5, "alder")
	schedule_event("NPCs", npc_move_event, alder_workshop_start + 12, ["alder", -475])
	schedule_event("NPCs", npc_move_event, alder_lookout_start + 0, ["alder", 0]) # workshop to elevator
	schedule_event("NPCs", npc_jump_event, alder_lookout_start + 5, ["alder", 0.2])
	schedule_elevator_to_lookout(alder_lookout_start + 8, "alder")
	schedule_event("NPCs", npc_move_event, alder_lookout_to_workshop_start + 0, ["alder", 0]) # lookout to elevator
	schedule_event("NPCs", npc_jump_event, alder_lookout_to_workshop_start + 8.5, ["alder", 0.2])
	schedule_elevator_to_workshop(alder_lookout_to_workshop_start + 9.5, "alder")
	schedule_event("NPCs", npc_move_event, alder_lookout_to_workshop_start + 15, ["alder", -475])
	
	# Collapsing blocks
	schedule_event("Collapsible", collapse_event, restaurant_collapse, ["RestaurantRoof"])
	schedule_event("Collapsible", collapse_event, outlook_collapse, ["Outlook"])
	
func schedule_sorrel_to_fountain(time, npc_name): # Assumes x = 10, outside Sorrel's house, from the right
	schedule_event("NPCs", npc_jump_event, time + 0, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 0, [npc_name, -150])
	schedule_event("NPCs", npc_move_event, time + 4, [npc_name, -50])
	schedule_event("NPCs", npc_jump_event, time + 4, [npc_name, 0.1])
	schedule_event("NPCs", npc_move_event, time + 6, [npc_name, 25])
	schedule_event("NPCs", npc_jump_event, time + 6.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 7, [npc_name, -30])
	schedule_event("NPCs", npc_jump_event, time + 7.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 8, [npc_name, -5])
	schedule_event("NPCs", npc_jump_event, time + 8.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 9, [npc_name, -40])
	schedule_event("NPCs", npc_jump_event, time + 9.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 10, [npc_name, -370])
	schedule_event("NPCs", npc_jump_event, time + 10.1, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 10.4, [npc_name, 0.15])
	schedule_event("NPCs", npc_jump_event, time + 12.2, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 13.6, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 14.5, [npc_name, -270])
	schedule_event("NPCs", npc_jump_event, time + 14.5, [npc_name, 0.1])
	schedule_event("NPCs", npc_move_event, time + 17, [npc_name, -350])
	schedule_event("NPCs", npc_jump_event, time + 17.2, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 18, [npc_name, -150])
	schedule_event("NPCs", npc_jump_event, time + 18, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 19.1, [npc_name, 0.2])

func schedule_fountain_to_restaurant(time, npc_name): # Assumes x = -150, at fountain, from the left
	schedule_event("NPCs", npc_move_event, time + 0, [npc_name, 270])
	schedule_event("NPCs", npc_jump_event, time + 3, [npc_name, 0.1])
	schedule_event("NPCs", npc_move_event, time + 5, [npc_name, 250])

func schedule_restaurant_to_elevator(time, npc_name): # Assumes x = 250, outside restaurant, from the right
	schedule_event("NPCs", npc_move_event, time + 0, [npc_name, 120])
	schedule_event("NPCs", npc_jump_event, time + 0, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 0.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 2, [npc_name, 160])
	schedule_event("NPCs", npc_jump_event, time + 2.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 3, [npc_name, 80])
	schedule_event("NPCs", npc_jump_event, time + 3.2, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 4, [npc_name, 160])
	schedule_event("NPCs", npc_jump_event, time + 4.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 4.6, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 5.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 5.6, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 6, [npc_name, 20])
	schedule_event("NPCs", npc_jump_event, time + 8, [npc_name, 0.3])
	schedule_event("NPCs", npc_move_event, time + 8.3, [npc_name, 30])
	schedule_event("NPCs", npc_jump_event, time + 9, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 9, [npc_name, -10])
	schedule_event("NPCs", npc_move_event, time + 10, [npc_name, 30])
	schedule_event("NPCs", npc_jump_event, time + 10.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 11, [npc_name, -30])
	schedule_event("NPCs", npc_jump_event, time + 11.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 11.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 12.5, [npc_name, 30])
	schedule_event("NPCs", npc_jump_event, time + 12.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 12.9, [npc_name, 0.1])
	schedule_event("NPCs", npc_move_event, time + 14, [npc_name, -30])
	schedule_event("NPCs", npc_jump_event, time + 14.1, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 14.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 15.5, [npc_name, 26])
	schedule_event("NPCs", npc_jump_event, time + 15.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 16, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 17.5, [npc_name, -30])
	schedule_event("NPCs", npc_jump_event, time + 17.6, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 18.5, [npc_name, 48])
	schedule_event("NPCs", npc_jump_event, time + 18.3, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 18.9, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 20, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 20.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 22, [npc_name, -30])
	schedule_event("NPCs", npc_jump_event, time + 21.8, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 22.3, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 23, [npc_name, 30])
	schedule_event("NPCs", npc_jump_event, time + 23.2, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 23.7, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 24.5, [npc_name, 0])
	schedule_event("NPCs", npc_jump_event, time + 24.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 25, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 25.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 26, [npc_name, 0.2])

func schedule_elevator_to_lookout(time, npc_name): # Assumes x = 0, at elevator top
	schedule_event("NPCs", npc_move_event, time + 0, [npc_name, 900])
	schedule_event("NPCs", npc_jump_event, time + 0, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 4.3 - 1, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 4.75 - 1, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 5.2 - 1, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 5.65 - 1, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 7.3 - 1, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 7.75 - 1, [npc_name, 0.1])

func schedule_elevator_to_workshop(time, npc_name): # Assumes x = 0, at elevator top
	schedule_event("NPCs", npc_move_event, time + 0, [npc_name, -270])
	schedule_event("NPCs", npc_jump_event, time + 0, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 1.5, [npc_name, 0.1])
	schedule_event("NPCs", npc_move_event, time + 3.5, [npc_name, -250])

func schedule_workshop_to_launchpad(time, npc_name): # Assumes x = -250, ouside workshop, from the right
	schedule_event("NPCs", npc_move_event, time + 0, [npc_name, 64])
	schedule_event("NPCs", npc_jump_event, time + 0, [npc_name, 0.1])
	schedule_event("NPCs", npc_jump_event, time + 2.4, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 3.2, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 4, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 4.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 5, [npc_name, 0])
	schedule_event("NPCs", npc_jump_event, time + 5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 5.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 6, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 6.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 7, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 7.5, [npc_name, 0.2])
	schedule_event("NPCs", npc_jump_event, time + 8, [npc_name, 0.2])
	schedule_event("NPCs", npc_move_event, time + 8, [npc_name, 48])

func save_kousa():
	schedule_event("NPCs", npc_move_event, 1, ["kousa", 0])
	schedule_event("NPCs", npc_jump_event, 1.8, ["kousa", 0.1])
	schedule_event("NPCs", npc_jump_event, 3.3, ["kousa", 0.1])
	schedule_event("NPCs", npc_jump_event, 3.9, ["kousa", 0.1])
	schedule_event("NPCs", npc_move_event, 5, ["kousa", -48])
	schedule_event("NPCs", npc_jump_event, 5, ["kousa", 0.2])
	schedule_event("NPCs", npc_move_event, 6, ["kousa", 48])
	schedule_event("NPCs", npc_jump_event, 6.2, ["kousa", 0.2])
	schedule_event("NPCs", npc_jump_event, 6.7, ["kousa", 0.2])
	schedule_event("NPCs", npc_move_event, 7.5, ["kousa", -64])
	schedule_event("NPCs", npc_jump_event, 7.3, ["kousa", 0.2])
	schedule_event("NPCs", npc_jump_event, 7.7, ["kousa", 0.2])
	schedule_event("NPCs", npc_jump_event, 8.3, ["kousa", 0.1])
	schedule_event("NPCs", npc_move_event, 9, ["kousa", 25])
	schedule_event("NPCs", npc_jump_event, 9, ["kousa", 0.2])
	schedule_event("NPCs", npc_jump_event, 9.5, ["kousa", 0.2])
	schedule_event("NPCs", npc_move_event, 11, ["kousa", 10])

	schedule_sorrel_to_fountain(11.5, "kousa")
	schedule_fountain_to_restaurant(34, "kousa")
	schedule_restaurant_to_elevator(40, "kousa")
	schedule_elevator_to_workshop(67, "kousa")
	schedule_workshop_to_launchpad(72, "kousa")

func save(npc):
	if npc == "kousa":
		save_kousa()
	elif npc == "wattle":
		save_wattle()
	elif npc == "alder":
		save_alder()
	else:
		print("INVALID SAVE ATTEMPT")

func save_wattle():
	schedule_event("NPCs", npc_move_event, 1, ["wattle", 16])
	
func save_alder():
	schedule_event("NPCs", npc_move_event, 1, ["alder", -250])
	schedule_workshop_to_launchpad(4, "alder")

func schedule_event(event_group, event_name, time_start, event_args):
#	print("Event: ", event_name, " will be called in ", time_start, " seconds")
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true 
	timer.wait_time = time_start
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	timer.timeout.connect(func():
		var call_group_args = [event_group, event_name] + event_args
		get_tree().callv("call_group", call_group_args)
		print(event_name, " activated!"))
	timer.start()

func _character_died(name):
	inverted_timer = inverted_duration
	
	if name == "player":
		print("Game over!")
	
func _physics_process(delta):
	inverted_timer = max(0, inverted_timer - delta)
	shader_material.set_shader_parameter("inverted", inverted_timer != 0)
	
	var curTime = previous_time + delta
	if int(curTime / 10) != int(previous_time / 10):
		print("Time: " + str(int(curTime / 10) * 10))
	previous_time = curTime
