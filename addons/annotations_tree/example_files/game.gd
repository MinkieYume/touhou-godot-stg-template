extends Node

#TODO: Add features

#FIXME: fix name issue
var vairable : int = 0

#BUG: This functions don't return -1 when an invalid input occurs
func add_two(value) -> int:
	if value is int:
		return value + 2
	return value

#TODO: test 2
