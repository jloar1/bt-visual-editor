extends Control

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _input(event):
	if event is InputEventMouseMotion:
		if $button.pressed:
			$nodes.set_position($nodes.get_position() + event.relative)

func free_recursive(node):
	if node.get_child_count() > 0:
		for n in node.get_children():
			free_recursive(n)
	node.get_parent().remove_child(node)
	node.queue_free()

func arrange_tree(node, is_root = false):
	if node is Button and node.get_node('nodes') != null:
		if node.get_node('nodes').get_child_count() > 0:
			node.space = 0
			for n in node.get_node('nodes').get_children():
				node.space += arrange_tree(n)
	
	if is_root:
		arrange_tree_spatial(node, true)
	
	return node.space

func arrange_tree_spatial(node, is_root = false):
	if node is Button and node.get_node('nodes') != null:
		if node.get_node('nodes').get_child_count() > 0:
			for n in node.get_node('nodes').get_children():
				arrange_tree_spatial(n)
		
		if is_root:
			node.rect_position.x = 960
			node.rect_position.y = 100
		elif node.get_parent().get_child_count() == 1:
			node.rect_position.x = 0
			node.rect_position.y = 120
			node.get_parent().get_parent().used_space += node.space
		else:
			node.rect_position.x = -(node.get_parent().get_parent().space / 2) + node.get_parent().get_parent().used_space + (node.space / 2)
			node.rect_position.y = 120
			node.get_parent().get_parent().used_space += node.space
		
		node.draw_lines()

func _on_create_pressed():
	var lines = $text_edit.text.split('\n')
	if get_node('nodes/root') != null:
		free_recursive(get_node('nodes/root'))
	
	$nodes.set_position(Vector2(0, 0))
	
	for line in lines:
		if line.find('.nodes.append') != -1:
			var start = 0
			var end = line.find('.nodes.append')
			var parent_name = line.substr(start, end).strip_edges()
			
			start = line.find('(', end) + 1
			end = line.find(')', start) - start
			var node_name = line.substr(start, end).strip_edges()
			
			var node = find_node(node_name, true, false)
			var parent = find_node(parent_name, true, false)
			
			if node.get_parent() != null:
				node.get_parent().remove_child(node)
			if parent.get_node('nodes') != null:
				parent.get_node('nodes').add_child(node)
			
		elif line.find('=') != -1:
			var node = load("res://node.tscn")
			node = node.instance()
			$nodes.add_child(node)
			node.string = line
			node.update()
	
	if get_node('nodes/root') != null:
		arrange_tree(get_node('nodes/root'),true)
