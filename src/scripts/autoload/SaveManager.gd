extends Node

# Save system for the game
const SAVE_SLOT_COUNT = 3
const SAVE_PREFIX = "survive_save_"

# Signals
signal game_save_requested()
signal game_load_requested()
signal save_completed(slot: int)
signal load_completed(slot: int)
signal save_failed(slot: int, error: String)
signal load_failed(slot: int, error: String)

func _ready():
    print("SaveManager initialized")

func save_game(save_data: Dictionary, slot: int = 0) -> bool:
    if slot < 0 or slot >= SAVE_SLOT_COUNT:
        push_error("Invalid save slot: ", slot)
        return false

    var save_path = "user://%s%d.save" % [SAVE_PREFIX, slot]

    # Add metadata
    save_data["metadata"] = {
        "version": GameManager.version,
        "timestamp": Time.get_time_dict_from_system(),
        "play_time": OS.get_time_dict_from_system()
    }

    var file = FileAccess.open(save_path, FileAccess.WRITE)
    if file:
        file.store_var(save_data)
        file.close()
        save_completed.emit(slot)
        return true
    else:
        var error = "Failed to save to slot %d" % slot
        push_error(error)
        save_failed.emit(slot, error)
        return false

func load_game(slot: int = 0) -> Dictionary:
    if slot < 0 or slot >= SAVE_SLOT_COUNT:
        push_error("Invalid save slot: ", slot)
        return {}

    var save_path = "user://%s%d.save" % [SAVE_PREFIX, slot]

    if not FileAccess.file_exists(save_path):
        var error = "Save file does not exist: %s" % save_path
        push_error(error)
        load_failed.emit(slot, error)
        return {}

    var file = FileAccess.open(save_path, FileAccess.READ)
    if file:
        var save_data = file.get_var()
        file.close()
        load_completed.emit(slot)
        return save_data
    else:
        var error = "Failed to load from slot %d" % slot
        push_error(error)
        load_failed.emit(slot, error)
        return {}

func delete_save(slot: int) -> bool:
    if slot < 0 or slot >= SAVE_SLOT_COUNT:
        push_error("Invalid save slot: ", slot)
        return false

    var save_path = "user://%s%d.save" % [SAVE_PREFIX, slot]

    if FileAccess.file_exists(save_path):
        var dir = DirAccess.open("user://")
        if dir:
            var err = dir.remove(save_path)
            if err == OK:
                return true

    return false

func get_save_info(slot: int) -> Dictionary:
    var save_data = load_game(slot)
    if save_data.has("metadata"):
        return save_data["metadata"]
    return {}

func list_saves() -> Array:
    var saves = []
    for i in range(SAVE_SLOT_COUNT):
        var info = get_save_info(i)
        if not info.is_empty():
            saves.append({
                "slot": i,
                "info": info
            })
    return saves

func request_save():
    game_save_requested.emit()

func request_load():
    game_load_requested.emit()
