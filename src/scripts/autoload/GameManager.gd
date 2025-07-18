extends Node

# Game state management
enum GameState {
    MENU,
    PLAYING,
    PAUSED,
    INVENTORY,
    CRAFTING,
    SETTINGS
}

# Game configuration
@export var game_title: String = "Survive"
@export var version: String = "1.0.0"

# Game state
var current_state: GameState = GameState.MENU
var is_paused: bool = false

# Player data
var player_health: int = 100
var player_hunger: int = 100
var player_thirst: int = 100
var player_stamina: int = 100

# Game settings
var game_settings: Dictionary = {
    "master_volume": 1.0,
    "sfx_volume": 1.0,
    "music_volume": 1.0,
    "mouse_sensitivity": 1.0,
    "fullscreen": false,
    "vsync": true
}

# Signals
signal game_state_changed(new_state: GameState)
signal player_stats_changed(health: int, hunger: int, thirst: int, stamina: int)
signal game_saved()
signal game_loaded()

func _ready():
    # Initialize game
    load_settings()
    print("GameManager initialized")

    # Connect to save system
    SaveManager.game_save_requested.connect(_on_save_requested)
    SaveManager.game_load_requested.connect(_on_load_requested)

func change_state(new_state: GameState):
    if current_state == new_state:
        return

    var old_state = current_state
    current_state = new_state

    # Handle state transitions
    match new_state:
        GameState.PAUSED:
            get_tree().paused = true
            is_paused = true
        GameState.PLAYING:
            get_tree().paused = false
            is_paused = false
        _:
            get_tree().paused = false
            is_paused = false

    game_state_changed.emit(new_state)
    print("Game state changed from ", old_state, " to ", new_state)

func toggle_pause():
    if current_state == GameState.PLAYING:
        change_state(GameState.PAUSED)
    elif current_state == GameState.PAUSED:
        change_state(GameState.PLAYING)

func update_player_stats(health: int = -1, hunger: int = -1, thirst: int = -1, stamina: int = -1):
    if health != -1:
        player_health = clamp(health, 0, 100)
    if hunger != -1:
        player_hunger = clamp(hunger, 0, 100)
    if thirst != -1:
        player_thirst = clamp(thirst, 0, 100)
    if stamina != -1:
        player_stamina = clamp(stamina, 0, 100)

    player_stats_changed.emit(player_health, player_hunger, player_thirst, player_stamina)

func save_settings():
    var config = ConfigFile.new()
    for key in game_settings.keys():
        config.set_value("settings", key, game_settings[key])

    var err = config.save("user://settings.cfg")
    if err != OK:
        push_error("Failed to save settings: ", err)

func load_settings():
    var config = ConfigFile.new()
    var err = config.load("user://settings.cfg")

    if err == OK:
        for key in game_settings.keys():
            if config.has_section_key("settings", key):
                game_settings[key] = config.get_value("settings", key)

    apply_settings()

func apply_settings():
    # Apply audio settings
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index("Master"),
        linear_to_db(game_settings["master_volume"])
    )
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index("SFX"),
        linear_to_db(game_settings["sfx_volume"])
    )
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index("Music"),
        linear_to_db(game_settings["music_volume"])
    )

    # Apply display settings
    DisplayServer.window_set_vsync_mode(
        DisplayServer.VSYNC_ENABLED if game_settings["vsync"] else DisplayServer.VSYNC_DISABLED
    )

    if game_settings["fullscreen"]:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_save_requested():
    # Save game data
    var save_data = {
        "player_stats": {
            "health": player_health,
            "hunger": player_hunger,
            "thirst": player_thirst,
            "stamina": player_stamina
        },
        "settings": game_settings,
        "timestamp": Time.get_time_dict_from_system()
    }

    SaveManager.save_game(save_data)
    game_saved.emit()

func _on_load_requested():
    var save_data = SaveManager.load_game()
    if save_data:
        if save_data.has("player_stats"):
            var stats = save_data["player_stats"]
            update_player_stats(
                stats.get("health", 100),
                stats.get("hunger", 100),
                stats.get("thirst", 100),
                stats.get("stamina", 100)
            )

        if save_data.has("settings"):
            game_settings = save_data["settings"]
            apply_settings()

        game_loaded.emit()
