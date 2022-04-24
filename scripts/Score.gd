extends Label

export var score_number = "1";

var curr_score = 0;

func _ready():
	if score_number == "1":
		get_parent().get_parent().get_node("CanvasModulate/Goal2").connect("goal_signal",self,"_on_goal");
	else:
		get_parent().get_parent().get_node("CanvasModulate/Goal1").connect("goal_signal",self,"_on_goal");

func _process(delta):
	text = str(curr_score);
	
func _on_goal(goal_number):
	curr_score += 1;
	
