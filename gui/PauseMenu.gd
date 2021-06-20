extends CanvasLayer
class_name PauseMenu

# Member variables
const SAVE_PATH : String = "user://saves/"
const MAX_SAVE_COUNT : int = 5

export (String) var start_animation : String = "stop"

onready var animation_player : AnimationPlayer = $AnimationPlayer
# buttons contains the main buttons: Continue, NewGame, LoadGame, SaveGame, Options
onready var buttons : VBoxContainer = $MainMenu/HBox/Buttons
# list contains a list of save files and three buttons: ActionButton, Delete, Back
onready var savefiles : CenterContainer = $MainMenu/HBox/Savefiles
# options contains a grid of settings: Volume
onready var options : CenterContainer = $MainMenu/HBox/Options
# action_button will either load or save file depending on the mode (see below)
onready var action_button : Button = $MainMenu/HBox/Savefiles/VBox/Buttons/ActionButton
# savefile_list contains a list of save files
onready var savefile_list : ItemList = $MainMenu/HBox/Savefiles/VBox/ItemList
# confirmation dialog is used to warn the user about irreversible changes
onready var confirm_dialog : ConfirmationDialog = $ConfirmationDialog

# mode determines the action executed by the action_button
var mode : String = "Save Game"

func _ready():
  pause_mode = PAUSE_MODE_PROCESS
  animation_player.play(start_animation)
  options.back_button.connect("pressed", self, "_show_buttons")

func _input(event : InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    get_tree().paused = !get_tree().paused # toggle pause status
    if get_tree().paused:
      animation_player.play("fade")
    else:
      animation_player.play_backwards("fade")
      yield(animation_player, "animation_finished")
      _show_buttons() # show buttons after the animation finishes

func _continue() -> void:
  animation_player.play_backwards("fade")
  get_tree().paused = false

func _new_game(delay : float = 0.5) -> void:
  yield(get_tree().create_timer(delay), "timeout")
  assert(get_tree().change_scene("res://Main.tscn") == OK)
  get_tree().paused = false

func _options() -> void:
  buttons.visible = false
  savefiles.visible = false
  options.visible = true

func _show_load_list() -> void:
  # Show list with save files and rename action button to "Load Game"
  _show_list("Load Game")

func _show_save_list() -> void:
  # Show list with save files and rename action button to "Save Game"
  _show_list("Save Game")
  savefile_list.add_item("[New Save File]")

func _execute_action() -> void:
  # Load game or save file depending on the mode of the action_button
  var indices = savefile_list.get_selected_items()
  var save_file : String
  for idx in indices:
    save_file = savefile_list.get_item_text(idx)
  match mode:
    "Save Game":
      _save_game(save_file)
    "Load Game":
      _load_game(save_file)

func _show_list(new_mode : String) -> void:
  # Show list with save files
  buttons.visible = false
  options.visible = false
  savefiles.visible = true
  mode = new_mode
  action_button.text = mode
  _show_files()

func _show_files() -> void:
  savefile_list.clear()           # Clear the item list
  var dir = Directory.new()
  if !dir.dir_exists(SAVE_PATH):  # Create save directory if it doesn't exist
    dir.make_dir(SAVE_PATH)

  dir.open(SAVE_PATH)
  dir.list_dir_begin(true, true)  # Skip_navigational and skip_hidden
  var file = dir.get_next()
  while file != "":
    if file.ends_with(".dat"):
      savefile_list.add_item(file.replace(".dat", ""))
      file = dir.get_next()

func _show_buttons() -> void:
  savefiles.visible = false
  options.visible = false
  buttons.visible = true

func _load_game(file_name : String) -> void:
  var filepath = SAVE_PATH + file_name + ".dat"
  # Warn users that unsaved progress will be lost
  var file = File.new()
  if file.open_encrypted_with_pass(filepath, File.READ, "pass") == OK:
    Globals.data = file.get_var()
    file.close()

func _save_game(file_name : String) -> void:
  var filepath = SAVE_PATH + file_name + ".dat"
  var dir = Directory.new()
  if dir.file_exists(filepath):  # Ask user if they want to overwrite
    confirm_dialog.window_title = "Are you sure you want to overwrite " + file_name + "?"
    confirm_dialog.show()
    yield(confirm_dialog, "confirmed")
  else: # Ask user for the filename
    pass
  var file = File.new()
  if file.open_encrypted_with_pass(filepath, File.WRITE, "pass") == OK:
    file.store_var(Globals.data)
    file.close()
