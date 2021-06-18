extends Furniture

# Member variables
var is_off : bool = true

func interact(body : Player) -> void:
  if is_off:
    if body.tools.has("Lighter"):
      Util.swap_message(body.number, "Oven is turned on!!")
      $Sprite.play("on")
      $Audio.play()
      is_off = false
      
      if body.tools.has("Stuffed crow"):
        $Timer.start()
        yield($Timer, "timeout")
        Util.swap_message(body.number, "Put stuffed crow in the oven? (E)")
    else:
      Util.swap_message(body.number, "I need something to turn on the oven")
      Util.shake()

  elif !item_collected:
    if body.tools.has("Stuffed crow"):
      Util.swap_message(body.number, collected)
      body.collect_tool("True meal")
      item_collected = true
    else:
      Util.swap_message(body.number, "I have nothing to cook")
      Util.shake()
