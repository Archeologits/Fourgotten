extends Node


# Declare member variables here. Examples:
var hud
var players : Array

const VIEWPORT_PATH : String = "Players/HBox/Player%s/Container/Viewport"
# Called when the node enters the scene tree for the first time.
func _ready():

  for i in range(3):
#    print("HBox/Player%s/Viewport" % i)
    var viewport : Viewport = get_node(VIEWPORT_PATH % i)
    viewport.world_2d = $World/Viewport.world_2d
    viewport.get_node("CameraX").target = $World/Viewport/Game.players[i]
#    $HBox/Player/Viewport.world_2d = $World/Viewport.world_2d
#    $HBox/ViewportContainer/Viewport/CameraX.target = 
#  $HBoxContainer/ViewportContainer/Viewport.world_2d = get_viewport().world_2d
#  $HBoxContainer/ViewportContainer/Viewport/CameraX.target = $Main.players[0]
  
  hud = $HUD
#  Util.main = self
#  Util.label = get_node("ViewportContainer/Viewport/HUD/Popup/Label")
#  Util.label = Util.hud.get_node("Popup/Label")
#  Util.label = get_node("HUD/Popup/Label")
#  $Popup.show()
#  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
