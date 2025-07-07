import 'dart:convert';

/// Represents a command that can be sent to the VS Code extension
class ExtensionCommand {
  final String action;
  final Map<String, dynamic>? parameters;

  ExtensionCommand({
    required this.action,
    this.parameters,
  });

  String toJsonString() {
    final Map<String, dynamic> json = {
      'action': action,
      if (parameters != null) ...parameters!,
    };
    return jsonEncode(json);
  }

  factory ExtensionCommand.openFile() {
    return ExtensionCommand(action: 'openFile');
  }

  factory ExtensionCommand.showMessage(String text) {
    return ExtensionCommand(
      action: 'showMessage',
      parameters: {'text': text},
    );
  }

  factory ExtensionCommand.getWorkspace() {
    return ExtensionCommand(action: 'getWorkspace');
  }

  factory ExtensionCommand.createFile() {
    return ExtensionCommand(action: 'createFile');
  }

  factory ExtensionCommand.runTerminalCommand(String command) {
    return ExtensionCommand(
      action: 'runTerminalCommand',
      parameters: {'command': command},
    );
  }

  @override
  String toString() {
    return 'ExtensionCommand(action: $action, parameters: $parameters)';
  }
}
