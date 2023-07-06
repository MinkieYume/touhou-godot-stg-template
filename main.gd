extends Node2D

@onready var toggle_button_audio = $Audio/ToggleButton
@onready var pressed_button_audio = $Audio/PressedButton 

func _on_buttons_toggle():
	toggle_button_audio.play()

func _on_buttons_pressed():
	pressed_button_audio.play()

func _on_difficult_panel_focused():
	pass

func _on_difficult_panel_unfocused():
	toggle_button_audio.play()
