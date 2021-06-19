extends AudioStreamPlayer

# Member variables
export (Dictionary) var sounds : Dictionary

func _play(ending : String) -> void:
  if !is_playing() and sounds.has(ending):
    stream = sounds.get(ending)
    play()
