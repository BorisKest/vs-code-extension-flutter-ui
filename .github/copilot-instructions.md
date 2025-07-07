<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Flutter Web Extension Project

This is a VS Code extension project that uses Flutter web for its user interface. Please use the get_vscode_api with a query as input to fetch the latest VS Code API references.

## Project Structure

- `src/extension.ts` - Main extension entry point with webview integration
- `flutter_ui/` - Flutter web application that serves as the extension UI
- The extension creates a webview panel that hosts the Flutter web app
- Communication between the extension and Flutter app happens via postMessage API

## Key Technologies

- TypeScript for VS Code extension
- Flutter/Dart for web UI
- VS Code Webview API for integration
- PostMessage for bidirectional communication

## Development Notes

- Build the Flutter web app with `flutter build web` before testing
- The extension loads the Flutter app from `flutter_ui/build/web/`
- Messages are exchanged using JSON format between extension and Flutter UI
- The Flutter app handles VS Code extension commands and displays results
