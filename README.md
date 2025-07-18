# Survive - A Godot 4 Survival Game

A 3D survival game built with Godot 4, featuring resource gathering, crafting, building, and exploration mechanics.

## Features

- **Survival Mechanics**: Health, hunger, thirst, and stamina systems
- **Resource Gathering**: Mining, chopping, hunting, and foraging
- **Crafting System**: Create tools, weapons, and structures
- **Building System**: Construct shelters and defensive structures
- **Day/Night Cycle**: Dynamic lighting and weather effects
- **Enemy AI**: Hostile creatures and environmental hazards
- **Save System**: Multiple save slots with metadata
- **Settings**: Audio, graphics, and gameplay customization

## Project Structure

```
survive/
├── project.godot          # Main project configuration
├── src/
│   ├── scenes/            # Game scenes
│   │   ├── ui/           # UI scenes
│   │   └── game/         # Gameplay scenes
│   ├── scripts/          # GDScript files
│   │   ├── autoload/     # Autoloaded singletons
│   │   ├── player/       # Player-related scripts
│   │   ├── enemies/      # Enemy AI scripts
│   │   ├── ui/          # UI scripts
│   │   └── systems/     # Game systems
│   ├── assets/          # Game assets
│   │   ├── textures/    # Texture files
│   │   ├── models/      # 3D models
│   │   ├── audio/       # Sound effects and music
│   │   └── fonts/       # Font files
│   └── ui/              # UI theme files
├── .gitignore            # Git ignore rules
└── README.md            # This file
```

## Getting Started

### Prerequisites

- Godot 4.2 or later
- Git (for version control)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd survive
   ```

2. Open the project in Godot:
   - Launch Godot 4.2+
   - Click "Import" and select the `project.godot` file
   - Click "Import & Edit"

### Development Setup

1. **Initial Setup**:
   - The project is already configured with proper folder structure
   - Autoload scripts are configured in `project.godot`
   - Input mappings are pre-configured

2. **Running the Game**:
   - Press F5 or click the play button in Godot
   - The game will start with the main menu

3. **Project Configuration**:
   - All autoloads are set up in `project.godot`
   - Input actions are defined for movement, interaction, and UI

## Controls

- **WASD** - Move character
- **Space** - Jump
- **E** - Interact
- **I** - Open inventory
- **Escape** - Pause menu

## Development

### Adding New Features

1. Create new scripts in appropriate folders under `src/scripts/`
2. Create corresponding scenes in `src/scenes/`
3. Update autoloads if needed in `project.godot`
4. Test thoroughly before committing

### Asset Guidelines

- **Textures**: Use PNG format, power-of-2 dimensions
- **Models**: Use GLTF format for 3D models
- **Audio**: Use OGG for music, WAV for sound effects
- **Fonts**: Use TTF format

### Code Style

- Use PascalCase for class names
- Use snake_case for variables and functions
- Use UPPER_SNAKE_CASE for constants
- Add comments for complex logic
- Follow Godot's GDScript style guide

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source. See LICENSE file for details.

## Roadmap

- [ ] Basic player movement and camera
- [ ] Resource gathering system
- [ ] Crafting system
- [ ] Building system
- [ ] Enemy AI
- [ ] Day/night cycle
- [ ] Weather system
- [ ] Multiplayer support
