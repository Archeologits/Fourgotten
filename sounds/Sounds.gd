extends Node

var sounds : Dictionary
var bgm : Dictionary

var last_played = ""

func _ready():
  bgm["theme"] = preload("res://sounds/awesome_music.wav")
  bgm["main_theme"] = preload("res://sounds/main_music.wav")

var last_room = -1

func playbgm(room):
  var play = Util.current_scene.get_node("BackgroundMusic")
  if room == 4 and last_room != 4:
    play.stop()
    play.stream = bgm["main_theme"]    
    play.play()
  elif room != 4 and last_room == 4:
    play.stop()
    play.stream = bgm["theme"]
    play.play()
  last_room = room

#func play(name):
#  var audio = Util.current_scene.get_node("AudioPlayer")
#  if !audio.is_playing():
#    audio.stream = sounds[name][0]
#    audio.play()
#    last_played = name
#  elif last_played != "" and sounds[name][1] > sounds[last_played][1]:
#    audio.stream = sounds[name][0]
#    audio.play()
#    last_played = name
