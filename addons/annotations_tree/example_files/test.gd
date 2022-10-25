#TODO: first TODO
class ForwardIterator:
	var start
	var current
	var end
	var increment

	func _init(start, stop, increment):
		self.start = start
		self.current = start
		self.end = stop
		#FIXME: first FIXME
		self.increment = increment

	# FIXME: uncatched FIXME annotation
	func should_continue():
		return (current < end)

	func _iter_init(arg):
		current = start
		#TODO: second TODO
		return should_continue()

	func _iter_next(arg):
		current += increment
		return should_continue()


	# Simple comment with the word TODO
	func _iter_get(arg):
		#FIXME: second FIXME
		return current
