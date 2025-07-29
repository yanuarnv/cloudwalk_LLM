


# NLP Flutter UI Builder 🧠

> Natural Language to Flutter UI: Build interfaces with conversational commands

![img.png](img.png)
![img_1.png](img_1.png)
![img_2.png](img_2.png)

## 🚀 Overview

NLP Flutter UI Builder is a Flutter application that transforms natural language into live Flutter UI components. Using advanced NLP processing, you can create, modify, and manage UI elements through simple conversational commands.

**Talk to your UI:**
```
"Add a red button with text 'Submit'"
"Change the background to blue"  
"Remove text widget number 1"
```

## ✨ Key Features

- 🎯 **Natural Language Processing** - Convert speech to UI commands
- ⚡ **Real-time UI Generation** - Instant visual feedback
- 🎨 **Smart Widget Management** - Add, remove, modify components
- 🔧 **Immutable State Management** - Clean architecture with BLoC pattern
- 📱 **Native Flutter Performance** - Smooth animations and interactions
- 🎪 **Dynamic Layout Editor** - Live UI manipulation

## 🏗️ Architecture

The project follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── application/
│   └── failure.dart              # Error handling
├── data/
│   └── data_sources/
│       └── processor.dart        # NLP processing interface
├── domain/
│   └── entities/
│       └── scaffold_entity.dart  # Core UI entities
└── presentation/
    └── logic/
        └── layout_editor_cubit.dart # State management with Cubit
```

## 🎯 Supported Commands

### Widget Creation
```bash
# Basic widgets
add text
add button
add textfield
add image

# With properties
add text color red size 18 text "Hello World"
add button text "Click Me" color blue width 200
add textfield hint "Enter email" radius 8
```

### Widget Modification
```bash
# Target by specific widget ID
change text1 color to green
change button2 text to "Updated Button"
change textfield1 hint to "New placeholder"
change image1 width to 200

# Target by widget type (affects first widget of that type)
change text color to blue
change button color to red

# Background modifications
change background to purple

# Alternative command syntax
update button1 size to 150
modify text2 weight to bold
```

### Widget Removal
```bash
# Remove by specific widget ID
remove text1        # Remove text widget with ID "text1"
remove button2      # Remove button widget with ID "button2"
remove textfield1   # Remove textfield widget with ID "textfield1"

# Remove by widget type (removes all widgets of that type)
remove button       # Remove all buttons
remove text         # Remove all text widgets

# Remove by instance number (alternative syntax)
remove button 2     # Remove button2
remove text 1       # Remove text1

# Remove everything
remove all          # Clear all widgets
```

## 🎨 Widget Support Matrix

| Widget Type | Supported Properties | Example |
|-------------|---------------------|---------|
| **Text** | `color`, `size`, `weight`, `family`, `text` | `add text color red size 20 weight bold` |
| **Button** | `color`, `width`, `text`, `elevation` | `add button text "Submit" color green elevation 4` |
| **TextField** | `color`, `width`, `hint`, `border`, `radius` | `add textfield hint "Name" radius 10` |
| **Image** | `width`, `height`, `fit`, `url` | `add image width 150 height 100 fit cover` |

## 🎨 Styling System

### Color Palette
**Predefined Colors:** `red`, `blue`, `green`, `yellow`, `orange`, `purple`, `pink`, `black`, `white`, `grey`, `transparent`

**Custom Hex Colors:** `0xFF0000`, `FF0000`

### Typography
**Font Weights:** `thin`, `light`, `normal`, `medium`, `semibold`, `bold`, `extrabold`, `black`

### Image Fitting
**Fit Options:** `fill`, `contain`, `cover`, `width`, `height`, `none`, `scale`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yanuarnv/cloudwalk_LLM.git
   cd cloudwalk_LLM
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Usage Examples

### Building a Login Screen
```bash
# Add title (will be assigned ID: text1)
add text text "Welcome Back" size 24 weight bold color blue

# Create input fields (will be assigned IDs: textfield1, textfield2)
add textfield hint "Email Address" radius 8
add textfield hint "Password" radius 8  

# Add login button (will be assigned ID: button1)
add button text "Sign In" color green width 300 elevation 2

# Modify specific widgets by ID
change text1 color to purple
change textfield1 color to lightgray
change button1 elevation to 4

# Change background theme
change background to white
```

### Creating a Profile Card
```bash
# Profile image
add image width 80 height 80 fit cover url "https://via.placeholder.com/80"

# User information
add text text "John Doe" size 18 weight semibold
add text text "Flutter Developer" size 14 color grey

# Action buttons
add button text "Follow" color blue width 100
add button text "Message" color purple width 100
```

### Dynamic Theme Switching
```bash
# Dark theme
change background to black
change text1 color to white
change text2 color to grey

# Light theme  
change background to white
change text1 color to black
change text2 color to grey
```

## 🧪 Testing the NLP System

Try these commands to explore the functionality:

```bash
# Widget creation tests (note the auto-generated IDs)
add text                    # Creates text1
add button text "First"     # Creates button1  
add button text "Second"    # Creates button2
add textfield hint "Input"  # Creates textfield1

# ID-specific property modifications
change text1 color to red
change text1 size to 20
change button1 color to blue
change button2 text to "Updated Second Button"
change textfield1 hint to "New placeholder"

# ID-specific removal tests
remove button1              # Remove first button only
remove text1                # Remove the text widget
remove textfield1           # Remove the textfield

# Type-based operations
remove button               # Remove all remaining buttons
remove all                  # Clear everything
```

## 🔧 Core Components

### LocalNlp Processor
The main NLP engine that processes natural language commands:
- **Token parsing** - Splits commands into actionable parts
- **Command routing** - Directs to appropriate handlers (add/remove/change)
- **Property validation** - Ensures valid widget-property combinations
- **Immutable updates** - Creates new state without mutations

### LayoutEditorCubit
State management using BLoC pattern:
- **Immutable state** - ScaffoldEntity updates
- **Error handling** - Graceful failure management
- **UI synchronization** - Real-time layout updates

## 🛠️ Technical Implementation

### NLP Command Processing Flow
1. **Input tokenization** - Split natural language into tokens
2. **Action identification** - Determine command type (add/remove/change)
3. **Target resolution** - Find specific widgets or properties
4. **Property validation** - Check supported properties for widget types
5. **State mutation** - Create new immutable state
6. **UI update** - Reflect changes in Flutter widgets

### Widget ID Management
- **Auto-generated IDs**: Widgets receive sequential IDs like `text1`, `text2`, `button1`, `button2`
- **Incremental numbering**: Based on existing widgets of the same type
- **Precise targeting**: Use exact IDs for specific widget modifications
- **Visual ID display**: The app shows widget IDs for easy reference

### Command Targeting Options
```bash
# By exact widget ID (most precise)
change button2 color to red
remove text1

# By widget type (affects first widget of that type)  
change button color to blue
remove text

# By instance number (alternative syntax)
remove button 2  # Same as "remove button2"
change text 1 size to 18  # Same as "change text1 size to 18"
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Known Issues

- Limited to single-screen scaffold layouts
- Complex nested widget structures not yet supported
- Case-sensitive hex color parsing
