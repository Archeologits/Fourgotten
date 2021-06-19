extends Item

# Member variables
export (String) var tool_name_2 : String = "Stuffed crow"
export (String) var collected_2 : String = "Got a stuffed crow!!"
var quill_collected : bool  = false

func interact(body : Player) -> void:
  if !quill_collected:
    Util.swap_message(body.number, collected)
    body.collect_tool(tool_name)
    quill_collected = true
  elif body.tools.has("Butter knife") and !item_collected:
    Util.swap_message(body.number, collected_2)
    body.collect_tool(tool_name_2)
    item_collected = true
#    $Audio.play()
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
