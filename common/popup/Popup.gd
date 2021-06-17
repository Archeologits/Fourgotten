extends CanvasLayer


func _process(delta):
  for child in $Inventory.get_children():
    child.queue_free()
  
  for item in Util.get_player().tools:
    var spr = TextureRect.new()
    var loaded = load("res://tool_images/" + item + ".png")
    if loaded == null:
      continue
    var tex = loaded.get_data()
    tex.resize(32, 32)
    var img = ImageTexture.new()
    img.create_from_image(tex)
    spr.texture = img
    $Inventory.add_child(spr)
