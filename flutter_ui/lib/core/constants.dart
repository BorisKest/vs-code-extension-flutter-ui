/// Application constants
class AppConstants {
  static const String appTitle = 'VS Code Extension UI';
  static const String appVersion = '1.0.0';

  // Message types
  static const String messageTypeFromExtension = 'fromExtension';
  static const String messageTypeFromFlutter = 'fromFlutter';
  static const String messageTypeError = 'error';

  // Extension commands
  static const String commandOpenFile = 'openFile';
  static const String commandShowMessage = 'showMessage';
  static const String commandGetWorkspace = 'getWorkspace';
  static const String commandCreateFile = 'createFile';
  static const String commandGetFileList = 'getFileList';
  static const String commandRunTerminalCommand = 'runTerminalCommand';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
}
