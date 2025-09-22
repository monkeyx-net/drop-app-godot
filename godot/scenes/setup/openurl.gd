extends RichTextLabel

func _ready() -> void:
	# Uses meta properties of the Ric Text Label.
	%HostServerRTL.meta_clicked.connect(func(url: String): OS.shell_open(url))
