# ConcentrationBar.gd
extends ProgressBar

# The '_on_BrainPort_brain_data_received' method updates the ProgressBar's value.
# It is called when the 'brain_data_received' signal is emitted by the BrainPort node.
func _on_BrainPort_brain_data_received(concentration_level: float):
	# Assuming concentration_level is normalized between 0 and 1.
	self.value = concentration_level * self.max_value
