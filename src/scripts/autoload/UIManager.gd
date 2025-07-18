extends Node

# UI management system
var current_ui: Control = null
var ui_stack: Array = []

# UI scene paths
const MAIN_MENU_PATH = "res://src/scenes/ui/MainMenu.tscn"
const PAUSE_MENU_PATH = "res://src/scenes/ui/PauseMenu.tscn"
const INVENTORY_UI_PATH = "res://src/scenes/ui/InventoryUI.tscn"
const HUD_PATH = "res://src/scenes/ui/HUD.tscn"

# Signals
signal ui_opened(ui_name: String)
signal ui_closed(ui_name: String)

func _ready():
    print("UIManager initialized")

func open_ui(ui_path: String, parent: Node = null) -> Control:
    if parent == null:
        parent = get_tree().get_root()

    # Close current UI if it exists
    if current_ui:
        close_current_ui()

    # Load and instantiate the new UI
    var ui_scene = load(ui_path)
    if not ui_scene:
        push_error("Failed to load UI scene: ", ui_path)
        return null

    var ui_instance = ui_scene.instantiate()
    if not ui_instance is Control:
        push_error("UI scene is not a Control: ", ui_path)
        return null

    # Add to parent
    parent.add_child(ui_instance)
    current_ui = ui_instance

    # Add to stack for navigation
    ui_stack.append(ui_instance)

    ui_opened.emit(ui_path)
    return ui_instance

func close_current_ui():
    if current_ui:
        var ui_name = current_ui.name
        current_ui.queue_free()
        current_ui = null

        # Remove from stack
        if ui_stack.size() > 0:
            ui_stack.pop_back()

        ui_closed.emit(ui_name)

func close_all_ui():
    while ui_stack.size() > 0:
        var ui = ui_stack.pop_back()
        if ui and is_instance_valid(ui):
            ui.queue_free()

    current_ui = null

func get_previous_ui() -> Control:
    if ui_stack.size() > 1:
        return ui_stack[-2]
    return null

func open_main_menu():
    return open_ui(MAIN_MENU_PATH)

func open_pause_menu():
    return open_ui(PAUSE_MENU_PATH)

func open_inventory():
    return open_ui(INVENTORY_UI_PATH)

func open_hud():
    return open_ui(HUD_PATH)

func is_ui_open() -> bool:
    return current_ui != null

func get_current_ui_name() -> String:
    if current_ui:
        return current_ui.name
    return ""
