extends Control


# Declare member variables here. Examples:
# listen to tempSlider and emit up to Manager

# OBSOLETE detached
func _on_tempSlider_value_changed(value):
	print("tempSlider_value_changed:", str(value))
	get_node("GridRow/RightUI/temp").text = str(value)
	
	var data = {"value": value, "gui": true}
	self.emit_signal("gui_input", data)# filter data
