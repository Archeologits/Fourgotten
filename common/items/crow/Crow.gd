extends Item

# Member variables
var quill_collected : bool  = false

func interact(body : Player) -> void:
  if !quill_collected:
    Util.swap_message("Got a quill!")
    body.collect_tool("Quill")
    quill_collected = true
  elif body.tools.has("Butter knife") and !item_collected:
    Util.swap_message("Got a stuffed crow!")
    body.collect_tool("Stuffed crow")
    item_collected = true
#    $Audio.play()
  else:
    Util.swap_message("...")
    Util.shake()
