extends CenterContainer
class_name Options

# Member variables
onready var music := AudioServer.get_bus_index("Music")
onready var effects := AudioServer.get_bus_index("Effects")

onready var music_volume : HSlider = $Grid/MusicVolume
onready var sound_effects : HSlider = $Grid/SoundEffects
onready var back_button : Button = $Grid/BackButton

func _on_redraw() -> void:
  music_volume.value = db2linear(AudioServer.get_bus_volume_db(music))
  sound_effects.value = db2linear(AudioServer.get_bus_volume_db(effects))

func _apply_changes() -> void:
  AudioServer.set_bus_volume_db(music, linear2db(music_volume.value))
  AudioServer.set_bus_volume_db(effects, linear2db(sound_effects.value))
