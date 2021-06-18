extends Node
class_name StateMachine

var state : Object
var parent : Object

func _ready() -> void:
  # Set the initial state to the first child node
  state = get_child(0)
  parent = get_parent()
  _enter_state()

func get_state() -> String:
  return state.name

func _enter_state() -> void:
  # Give the new state a reference to this state machine script
  state.fsm = self
  state.parent = self.parent
  state.enter()

func _change_to(new_state : String) -> void:
  state = get_node(new_state)
  _enter_state()

# Route Game Loop function calls to current state handler method (it must exist)
func _input(event : InputEvent) -> void:
  state.input(event)

func _process(delta : float) -> void:
  state.process(delta)

func _physics_process(delta : float) -> void:
  state.physics_process(delta)
