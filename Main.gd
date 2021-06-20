extends Node


# Declare member variables here. Examples:
var hud
var players : Array
var viewports : Array
var cameras : Array

const PLAYER_PATH : String = "Players/HBox/Player%s"
const VIEWPORT_PATH : String = "Players/HBox/Player%s/Container/Viewport"
# Called when the node enters the scene tree for the first time.
func _ready():
  Util.game = $World/Viewport/Game
  Util.main = self
  Util.hud = $HUD
  Util.label = Util.hud.get_node("Popup/Label")
#  Util.main.get_node("Popup").show()
  Util.set_message_stacks(3)
  Util.game.start()
  Util.hud.get_node("Popup").show()
  for i in range(3):
    players.push_back(get_node(PLAYER_PATH % i))
    viewports.push_back(get_node(VIEWPORT_PATH % i))
    viewports[i].world_2d = $World/Viewport.world_2d
    cameras.push_back(viewports[i].get_node("CameraX"))
    cameras[i].target = $World/Viewport/Game.players[i]
  
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
