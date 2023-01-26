extends Button

var mouse_over = false
var mouse_offset = Vector2()
var space = 180.0
var used_space = 0.0

var string = ''
var line = Line2D.new()

func _input(event):
	if event is InputEventMouseButton:
		if mouse_over and event.button_index == BUTTON_LEFT:
			mouse_offset = event.position - get_global_position()
	
	if event is InputEventMouseMotion:
		if mouse_over and Input.is_mouse_button_pressed(BUTTON_LEFT):
			set_global_position(event.position - mouse_offset)
			if line.get_parent() == self:
				line.points[1] = get_parent().get_parent().get_global_position() - get_global_position() + Vector2(70, 82)

func update():
	var start = 0
	var end = string.find('=')
	var node_name = string.substr(start, end).strip_edges()
	
	$node_name.text = 'Name: ' + node_name
	self.name = node_name
	
	start = string.find('bt.') + 3
	end = string.find('(', start) - start
	var node_type = string.substr(start, end).strip_edges()
	
	$node_type.text = 'Type: ' + node_type

func draw_lines():
	if get_parent().get_parent() is Button:
		add_child(line)
		
		line.width = 4
		line.default_color = Color(0.0, 0.0, 0.0, 0.8)
		line.z_index = -1
		line.show_behind_parent = true
		
		var points = PoolVector2Array()
		points.append(Vector2(70, -2))
		points.append(get_parent().get_parent().get_global_position() - get_global_position() + Vector2(70, 82))
		
		line.points = points
		

func _on_node_mouse_entered():
	mouse_over = true

func _on_node_mouse_exited():
	mouse_over = false
