# Flutter Web VS Code Extension

Example of an VS Code extension that uses Flutter web for its user interface.

## 🏗️ Architecture

### VS Code Extension (TypeScript)
```
src/
├── extension.ts          # Main extension entry point
├── models/              # Type definitions and interfaces
│   └── types.ts
├── services/            # Business logic layer
│   ├── flutterBuildService.ts    # Flutter build management
│   └── commandService.ts         # Command handling
└── utils/               # Utility functions
    └── htmlTemplates.ts
```

### Flutter Web UI (Dart)
```
lib/
├── main.dart            # Application entry point
├── core/                # Core application utilities
│   ├── constants.dart   # App constants
│   └── theme.dart       # VS Code theme styling
├── data/                # Data layer (external communication)
│   └── vscode_service.dart       # VS Code communication service
├── domain/              # Domain layer (business models)
│   └── models/
│       ├── extension_message.dart
│       └── extension_command.dart
└── presentation/        # Presentation layer (UI)
    ├── pages/
    │   └── extension_page.dart    # Main UI page
    ├── providers/
    │   └── extension_provider.dart # State management
    └── widgets/         # Reusable UI components
        ├── extension_header.dart
        ├── feature_button.dart
        ├── message_display.dart
        └── vscode_card.dart
```

## ✨ Features

### 🎨 Modern UI
- **VS Code Theme Integration**: Matches VS Code's dark theme perfectly
- **Professional Components**: Reusable, styled widgets following VS Code design patterns
- **Responsive Design**: Adapts to different panel sizes
- **Loading States**: Professional loading indicators and error handling

### 💬 Bidirectional Communication
- **Message Exchange**: Send and receive messages between extension and Flutter UI
- **Command System**: Structured command handling with JSON serialization
- **Real-time Updates**: Live message history and status updates

### 🛠️ Developer Tools
- **Terminal Integration**: Run terminal commands directly from the UI
- **Workspace Info**: Get current workspace details
- **File Operations**: Create files, open dialogs
- **Debug Tools**: Built-in debugging and diagnostics

### 🏛️ "Clean Architecture"
- **Separation of Concerns**: Clear boundaries between layers
- **State Management**: Provider pattern for reactive UI updates
- **Service Layer**: Dedicated services for different responsibilities
- **Type Safety**: Full TypeScript and Dart type definitions

## Quick Start

1. **Build the Flutter web app**:
   ```bash
   cd flutter_ui
   flutter pub get
   flutter build web
   ```

2. **Compile the extension**:
   ```bash
   npm run compile
   ```

3. **Launch the extension**:
   - Press `F5` to open a new Extension Development Host window
   - Open Command Palette (`Ctrl+Shift+P`)
   - Run "Open Flutter UI" command

## Commands

- `Flutter Extension: Open Flutter UI` - Opens the Flutter web interface in a webview panel
- `Hello World` - Shows a hello message and sends it to the Flutter UI if open

## Project Structure

```
├── src/
│   └── extension.ts          # Main extension entry point
├── flutter_ui/
│   ├── lib/
│   │   └── main.dart         # Flutter web application
│   ├── web/
│   │   ├── index.html        # Web entry point
│   │   └── manifest.json     # Web app manifest
│   └── build/web/            # Built Flutter web files
├── package.json              # Extension manifest
└── webpack.config.js         # Build configuration
```

## Requirements

- **Flutter SDK**: Version 3.8.1 or higher with web support enabled
- **Node.js**: Version 18 or higher
- **VS Code**: Version 1.101.0 or higher

To enable Flutter web support:
```bash
flutter config --enable-web
```

## Communication Protocol

The extension and Flutter app communicate via `postMessage` API:

### From Extension to Flutter:
```typescript
webview.postMessage({
  type: 'fromExtension',
  message: 'Your message here'
});
```

### From Flutter to Extension:
```dart
html.window.parent?.postMessage({
  'type': 'fromFlutter',
  'message': 'Your message here',
}, '*');
```

### Command Protocol:
Flutter can send JSON commands to trigger VS Code actions:
```json
{
  "action": "openFile|showMessage|getWorkspace|createFile",
  "text": "Optional text parameter"
}
```

## Development

1. **Watch mode for TypeScript**:
   ```bash
   npm run watch
   ```

2. **Build Flutter for development**:
   ```bash
   cd flutter_ui
   flutter build web --profile
   ```

3. **Hot reload**: Use `Ctrl+R` in the Extension Development Host to reload

## Building for Production

1. **Build Flutter for production**:
   ```bash
   cd flutter_ui
   flutter build web --release
   ```

2. **Package the extension**:
   ```bash
   npm run package
   ```

## Architecture

The extension uses VS Code's webview API to host a Flutter web application. Key components:

- **Extension Host**: TypeScript extension running in Node.js context
- **Webview**: Isolated browser context hosting the Flutter app
- **Message Bridge**: PostMessage API for communication
- **Command Handler**: Processes Flutter commands and executes VS Code actions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the Extension Development Host
5. Submit a pull request

## Known Issues

- Flutter web build files must exist before running the extension
- Hot reload requires manual webview refresh
- Some VS Code themes may not fully sync with Flutter UI

## Release Notes

### 0.0.1

- Initial release with Flutter web integration
- Basic bidirectional communication
- Sample commands and UI components

---

**Enjoy building VS Code extensions with Flutter!** 🚀

## Following extension guidelines

Ensure that you've read through the extensions guidelines and follow the best practices for creating your extension.

* [Extension Guidelines](https://code.visualstudio.com/api/references/extension-guidelines)

## Working with Markdown

You can author your README using Visual Studio Code. Here are some useful editor keyboard shortcuts:

* Split the editor (`Cmd+\` on macOS or `Ctrl+\` on Windows and Linux).
* Toggle preview (`Shift+Cmd+V` on macOS or `Shift+Ctrl+V` on Windows and Linux).
* Press `Ctrl+Space` (Windows, Linux, macOS) to see a list of Markdown snippets.

## For more information

* [Visual Studio Code's Markdown Support](http://code.visualstudio.com/docs/languages/markdown)
* [Markdown Syntax Reference](https://help.github.com/articles/markdown-basics/)

**Enjoy!**
