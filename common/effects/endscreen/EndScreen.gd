extends CanvasLayer

export (String) var path : String = "res://common/effects/endscreen/"

func _on_MainDoor_opened(player : Player) -> void:
#  sprite.texture = ImageTexture.new().create_from_image(load(path + "cold end.png"))
  var ending : String
  if player.tools.has("True meal"):
    ending = "true end" 
  elif player.id == "RGB":
    ending = "good end"
  elif player.id == "RB":
    ending = "cruel end"
  elif ["R", "B", "G"].has(player.id):
    ending = "cold end"
  $ColorRect.rect_size = get_viewport().size
  $CenterContainer/TextureRect.texture = load(path + ending + ".png")
  $AnimationPlayer.play("fade")
  Sounds.stop()
  $AudioStreamPlayer._play(ending)
  get_parent().switch_to_player(-1)
