extends CanvasLayer

export (String) var path : String = "res://common/effects/endscreen/"

func _on_MainDoor_opened(player : Player) -> void:
#  sprite.texture = ImageTexture.new().create_from_image(load(path + "cold end.png"))
  var ending : String
  match player.id:
    "B":
      ending = "cold end"
    "RB":
      ending = "cruel end"
    "RGB":
      ending = "good end"
  $ColorRect.rect_size = get_viewport().size
  $CenterContainer/TextureRect.texture = load(path + ending + ".png")
  $AnimationPlayer.play("fade")
  get_parent().switch_to_player(-1)
