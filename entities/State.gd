extends Node
class_name State

var fsm : StateMachine
var parent : Object

func enter() -> void:
  """ Play sound and animations """
  return

func exit(next_state : String) -> void:
  fsm._change_to(next_state)

func input(event : InputEvent) -> InputEvent:
  """ Input logic """
  return event

func process(_delta : float) -> void:
  """ State logic """
  return

func physics_process(_delta : float) -> void:
  """ State logic """
  return
