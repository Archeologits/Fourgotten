extends Furniture
class_name Oven

var is_off : bool = true

func interact(body : Player) -> void:
  if is_off:
    if body.tools.has("Lighter"):
      Util.swap_message("Oven is turned on!!")
      $Sprite.play("on")
      $Audio.play()
      is_off = false
    else:
      Util.swap_message("I need something to turn on the oven")
      Util.shake()
      
  elif !item_collected:
    if body.tools.has("Stuffed crow"):
      Util.swap_message(collected)
      body.collect_tool("True meal")
      item_collected = true
    else:
      Util.shake()
      Util.swap_message("I have nothing to cook")
