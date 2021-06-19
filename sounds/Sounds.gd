extends Node

# Member variables
var bgm : Dictionary

func _ready():
  bgm[0] = preload("res://sounds/BLUE ROOM MASTER.wav")
  bgm[1] = preload("res://sounds/GREEN ROOM MASTER.wav")
  bgm[2] = preload("res://sounds/RED ROOM MASTER.wav")
  bgm[3] = preload("res://sounds/main_music.wav")

func playbgm(room):
  var play = Util.current_scene.get_node("BackgroundMusic")
  play.stop()
  play.stream = bgm[room]
  play.play()

func stop():
  Util.current_scene.get_node("BackgroundMusic").stop()
