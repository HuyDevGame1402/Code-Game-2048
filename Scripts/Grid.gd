extends Node2D

var width : int = 4
var height : int  = 4
var board := []
var old_board := []
var x_start := 96
var y_start := 796
var offset := 128
var check = false
var is_move : bool = false
@onready var timer = $"../Timer"
@export var four_piece_chance : int
@export var two_piece : PackedScene
@export var four_piece : PackedScene
@export var piece_8 : PackedScene
@export var piece_16 : PackedScene
@export var piece_32 : PackedScene
@export var piece_64 : PackedScene
@export var piece_128 : PackedScene
@export var piece_256 : PackedScene
@export var piece_512 : PackedScene
@export var piece_1024 : PackedScene
@export var piece_2048 : PackedScene
@export var piece_4096 : PackedScene
@export var piece_8192 : PackedScene
@export var piece_16384 : PackedScene
@export var background_piece : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Khởi tạo bảng và các ô nền (background)
	for y in range(height):
		var row = []
		for x in range(width):
			# Tạo background_piece cho mỗi ô
			var bg_piece = background_piece.instantiate()
			add_child(bg_piece)
			bg_piece.position = Vector2(x_start + x * offset, y_start - y * offset)
			row.append(null)  # Để trống ô này trong bảng
		board.append(row)

	# Tạo một ô "2" hoặc "4" ngẫu nhiên
	spawn_piece()
	spawn_piece()
	#for i in range(3):
		#var chosen_pos = Vector2(i,1)
		#var piece : Node2D
		#if i == 2:
			#piece = four_piece.instantiate()
		#else:
			#piece = two_piece.instantiate()
		#board[chosen_pos.y][chosen_pos.x] = piece
		#add_child(piece)
		#piece.position = Vector2(x_start + chosen_pos.x * offset, y_start - chosen_pos.y * offset)
		
	#print(board)

# Hàm tạo một ô "2" hoặc "4" ngẫu nhiên trên màn hình
func spawn_piece():
	
	if is_board_full():
		$"../Button".visible = true
		print("Board is full. No spawn.")
		return
	
	if logic_spawn_piece() == 16:
		four_piece_chance = 50
	# Xác định nếu tạo "2" hay "4" dựa trên `four_piece_chance`
	var piece_scene
	if ((randf() * 100 > four_piece_chance)):
		
		piece_scene = four_piece
	else:
		piece_scene = two_piece
	var piece = piece_scene.instantiate()
	
	# Xác định vị trí ngẫu nhiên trống trong bảng
	var empty_positions = []
	for y in range(height):
		for x in range(width):
			if board[y][x] == null:
				empty_positions.append(Vector2(x, y))
	if empty_positions.size() > 0:
		var chosen_pos = empty_positions[randi() % empty_positions.size()]
	
		# Cập nhật bảng và đặt vị trí cho ô số
		board[chosen_pos.y][chosen_pos.x] = piece
		add_child(piece)
		piece.position = Vector2(x_start + chosen_pos.x * offset, y_start - chosen_pos.y * offset)

func check_value(value : int):
	match value:
		2:
			return two_piece
		4: 
			return four_piece
		8: 
			return piece_8
		16: 
			return piece_16
		32: 
			return piece_32
		64: 
			return piece_64
		128: 
			return piece_128
		256:
			return piece_256
		512:
			return piece_512
		1024:
			return piece_1024
		2048:
			return piece_2048
		4096:
			return piece_4096
		8192:
			return piece_8192
		16384:
			return piece_16384
		_:
			print("Hướng không hợp lệ")

func check_spawn(old_piece : Array):
	for y in range(height):
		for x in range(width):
			if old_piece[y][x] != board[y][x]:
				return true
	return false


func random_value(max_value : int):
	var rd = randf() * 100
	if rd <= 4:
		return max_value / 2
	if rd > 4 and rd < 20:
		return max_value / 4
	if rd > 20 and rd < 62:
		return max_value / 8
	if rd > 62:
		return max_value / 16 

func copy_board():
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(board[y][x])  # Sao chép từng phần tử
		old_board.append(row)

func set_state():
	for y in range(height):
		for x in range(width):
			if board[y][x] != null:
				if board[y][x].is_state:
					continue
				else:
					board[y][x].is_state = true
			else:
				continue

# Hàm di chuyển các piece sang trái
func move_left():
	copy_board()
	#print("Old board")
	#print(old_board)
	is_move = true
	for y in range(height):
		for x in range(1, width):
			if board[y][x] != null:
				var current_x = x
				while current_x > 0:
					if board[y][current_x - 1] == null:
						# Di chuyển piece sang trái nếu vị trí bên trái trống
						board[y][current_x - 1] = board[y][current_x]
						board[y][current_x] = null
						
						# Cập nhật vị trí piece trên màn hình với hiệu ứng tween
						var piece = board[y][current_x - 1]
						var target_position = Vector2(x_start + (current_x - 1) * offset, piece.position.y)
						
						# Tạo tween cho piece
						var tween = create_tween()
						tween.tween_property(piece, "position", target_position, 0.2)
						# Tiếp tục di chuyển sang trái nếu có thể
					elif board[y][current_x].value == board[y][current_x - 1].value and board[y][current_x - 1].is_state and board[y][current_x].is_state:
						#print("check sum value")
						var sum_value = board[y][current_x].value * 2
						var piece = check_value(sum_value).instantiate()
						#piece.value = board[current_y][x].value * 2  
						board[y][current_x].queue_free()  
						board[y][current_x] = null
						
						var pos_y = board[y][current_x - 1].position.y
						board[y][current_x - 1].queue_free()  
						board[y][current_x - 1] = null
						
						board[y][current_x - 1] = piece  
						board[y][current_x - 1].is_state = false
						print("SET STATE PIECE")
						print(board[y][current_x - 1].is_state)
						piece.position = Vector2(x_start + (current_x - 1) * offset, pos_y)  # Đặt vị trí
						add_child(piece)  
						bounce_effect(piece)
						#print("Created and moved a new piece!")
						#print(current_x)
					current_x -= 1
	#print("Board after moving left:", board)
	timer.start()
	await timer.timeout
	if check_spawn(old_board):
		spawn_piece()
	else:
		print("not spawn!")
	
	
# Di chuyển các piece sang phải
func move_right():
	copy_board()
	is_move = true
	for y in range(height):
		for x in range(width - 2, -1, -1):  # Duyệt từ phải sang trái
			if board[y][x] != null:
				var current_x = x
				while current_x < width - 1:
					if board[y][current_x + 1] == null:
						board[y][current_x + 1] = board[y][current_x]
						board[y][current_x] = null
						
						var piece = board[y][current_x + 1]
						var target_position = Vector2(x_start + (current_x + 1) * offset, piece.position.y)
						var tween = create_tween()
						tween.tween_property(piece, "position", target_position, 0.2)
					elif board[y][current_x].value == board[y][current_x + 1].value and board[y][current_x + 1].is_state and board[y][current_x].is_state:
						print("check sum value")
						var sum_value = board[y][current_x].value * 2
						var piece = check_value(sum_value).instantiate()  
						board[y][current_x].queue_free()  
						board[y][current_x] = null
						
						var pos_y = board[y][current_x + 1].position.y
						board[y][current_x + 1].queue_free()  
						board[y][current_x + 1] = null
						
						board[y][current_x + 1] = piece  
						board[y][current_x + 1].is_state = false
						print("SET STATE PIECE")
						print(board[y][current_x + 1].is_state)
						piece.position = Vector2(x_start + (current_x + 1) * offset, pos_y)  # Đặt vị trí
						add_child(piece)  
						#print("Created and moved a new piece!")
						#print(current_x)
						bounce_effect(piece)
					current_x += 1
	timer.start()
	await  timer.timeout
	if check_spawn(old_board):
		spawn_piece()
	
# Di chuyển các piece lên trên
#func move_down():
	#print(board)
	#for x in range(width):
		#for y in range(1, height):
			#if board[y][x] != null:
				#var current_y = y
				#while current_y > 0 and board[current_y - 1][x] != null:
					#if board[current_y - 1][x] == null:
						#board[current_y - 1][x] = board[current_y][x]
						#board[current_y][x] = null
						#
						#var piece = board[current_y - 1][x]
						#var target_position = Vector2(piece.position.x, y_start - (current_y - 1) * offset)
						#
						#var tween = create_tween()
						#tween.tween_property(piece, "position", target_position, 0.2)
						#print("move oke!")
					#current_y -= 1
	#print(board)
func move_down():
	copy_board()
	is_move = true
	for x in range(width):
		for y in range(1, height):
			if board[y][x] != null:
				var current_y = y
				while current_y > 0:
					# Nếu ô trên cùng là null, di chuyển ô hiện tại xuống
					if board[current_y - 1][x] == null:
						board[current_y - 1][x] = board[current_y][x]
						board[current_y][x] = null
						
						var piece = board[current_y - 1][x]
						var target_position = Vector2(piece.position.x, y_start - (current_y - 1) * offset)
						
						move_piece(piece, target_position)  # Gọi hàm di chuyển
						print("move oke!")
					
					elif board[current_y][x].value == board[current_y - 1][x].value and board[current_y - 1][x].is_state and board[current_y][x].is_state:
						var sum_value = board[current_y][x].value * 2
						var piece = check_value(sum_value).instantiate() 
						board[current_y][x].queue_free()  
						board[current_y][x] = null
						
						board[current_y - 1][x].queue_free()  
						board[current_y - 1][x] = null
						
						board[current_y - 1][x] = piece  
						board[current_y - 1][x].is_state = false
						print("SET STATE PIECE")
						print(board[current_y - 1][x].is_state)
						piece.position = Vector2(x_start + x * offset, y_start - (current_y - 1) * offset)  # Đặt vị trí
						add_child(piece)  
						
						#var target_position = Vector2(piece.position.x, y_start - (current_y - 1) * offset)
						#move_piece(piece, target_position)  # Di chuyển piece mới tạo lên
						#print("Created and moved a new piece!")
						##break  # Thoát vòng lặp nếu đã hợp nhất
						#print(current_y)
						bounce_effect(piece)
					current_y -= 1
	#print(board)
	timer.start()
	await timer.timeout
	if check_spawn(old_board):
		spawn_piece()
	

func move_piece(piece: Node2D, target_position: Vector2):
	# Tạo tween và di chuyển piece đến vị trí mục tiêu
	var tween = create_tween()
	tween.tween_property(piece, "position", target_position, 0.2)
	 # Tăng số lượng Tween đang hoạt động

# Di chuyển các piece xuống dưới
func move_up():
	copy_board()
	is_move = true
	for x in range(width):
		for y in range(height - 2, -1, -1):  # Duyệt từ dưới lên trên
			if board[y][x] != null:
				var current_y = y
				while current_y < height - 1:
					if board[current_y + 1][x] == null:
						board[current_y + 1][x] = board[current_y][x]
						board[current_y][x] = null
						
						var piece = board[current_y + 1][x]
						var target_position = Vector2(piece.position.x, y_start - (current_y + 1) * offset)
						
						var tween = create_tween()
						tween.tween_property(piece, "position", target_position, 0.2)
					elif board[current_y][x].value == board[current_y + 1][x].value and board[current_y + 1][x].is_state and board[current_y][x].is_state:
						var sum_value = board[current_y][x].value * 2
						var piece = check_value(sum_value).instantiate()
						board[current_y][x].queue_free()  
						board[current_y][x] = null
						
						board[current_y + 1][x].queue_free()  
						board[current_y + 1][x] = null
						
						board[current_y + 1][x] = piece  
						board[current_y + 1][x].is_state = false
						print("SET STATE PIECE")
						print(board[current_y + 1][x].is_state)
						piece.position = Vector2(x_start + x * offset, y_start - (current_y + 1) * offset)  # Đặt vị trí
						add_child(piece)  
						bounce_effect(piece)
						#var target_position = Vector2(piece.position.x, y_start - (current_y - 1) * offset)
						#move_piece(piece, target_position)  # Di chuyển piece mới tạo lên
						#print("Created and moved a new piece!")
						##break  # Thoát vòng lặp nếu đã hợp nhất
						#print(current_y)
					current_y += 1
	timer.start()
	await timer.timeout
	if check_spawn(old_board):
		spawn_piece()
	

func _input(event):
	if event.is_action_pressed("ui_left") and !is_move:
		move_left()
	elif event.is_action_pressed("ui_right") and !is_move:
		move_right()
	elif event.is_action_pressed("ui_down") and !is_move:
		move_down()
	elif event.is_action_pressed("ui_up") and !is_move:
		move_up()
	elif event.is_action_pressed("check_value"):
		logic_spawn_piece()

func _on_timer_timeout():
	is_move = false
	set_state()


func logic_spawn_piece():
	var temp_value = 2
	print(board)
	for y in range(height):
		for x in range(width):
			if board[y][x] != null:
				if board[y][x].value > temp_value:
					temp_value = board[y][x].value
	return temp_value

func is_board_full() -> bool:
	for y in range(height):
		for x in range(width):
			if board[y][x] == null:
				return false
	return true

func reload_game():
	get_tree().reload_current_scene()


func bounce_effect(piece: Node2D):
	var tween = create_tween()
	tween.tween_property(piece, "scale", Vector2(1.2, 1.2), 0.1).as_relative()
	tween.tween_property(piece, "scale", Vector2(1, 1), 0.1)


func _on_button_pressed() -> void:
	$"../Button".visible = false
	reload_game()
