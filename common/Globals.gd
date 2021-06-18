extends Node

# Member variables
var data : Dictionary = {}

func _ready():
  for player in range(3):
    data[player] = {}
    data[player]["room"] = -1

  data["Room1"] = {}
  data["Room2"] = {}
  data["Room3"] = {}  
  data["Room4"] = {}
