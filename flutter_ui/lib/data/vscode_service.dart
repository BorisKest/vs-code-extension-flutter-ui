import 'dart:js' as js;
import '../domain/models/extension_message.dart';
import '../domain/models/extension_command.dart';
import '../core/constants.dart';

/// Service for communicating with VS Code extension
class VSCodeService {
  static VSCodeService? _instance;

  VSCodeService._();

  static VSCodeService get instance {
    _instance ??= VSCodeService._();
    return _instance!;
  }

  /// Initialize VS Code API overrides and message handling
  Future<void> initialize() async {
    try {
      await _setupMessageHandler();
      print('VSCodeService initialized successfully');
    } catch (e) {
      print('Failed to initialize VSCodeService: $e');
      rethrow;
    }
  }

  /// Send a message to the VS Code extension
  Future<void> sendMessage(String message) async {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          try {
            if (window.vscode) {
              window.vscode.postMessage({
                type: '${AppConstants.messageTypeFromFlutter}',
                message: '$message'
              });
              console.log('Message sent to VS Code extension:', '$message');
            } else {
              console.error('VS Code API not available - window.vscode is undefined');
            }
          } catch (error) {
            console.error('Error sending message to VS Code:', error);
          }
        })();
        '''
      ]);
    } catch (e) {
      print('Failed to send message to extension: $e');
      rethrow;
    }
  }

  /// Send a command to the VS Code extension
  Future<void> sendCommand(ExtensionCommand command) async {
    await sendMessage(command.toJsonString());
  }

  /// Set up message handler for receiving messages from VS Code
  Future<void> _setupMessageHandler() async {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          try {
            // Listen for messages from VS Code extension
            window.addEventListener('message', function(event) {
              const data = event.data;
              if (data && data.type === '${AppConstants.messageTypeFromExtension}') {
                console.log('Received message from extension:', data.message);
                // Trigger Flutter callback
                window.flutterMessageReceived && window.flutterMessageReceived(data.message);
              }
            });
            console.log('VS Code message handler set up');
          } catch (error) {
            console.error('Error setting up message handler:', error);
          }
        })();
        '''
      ]);
    } catch (e) {
      print('Failed to setup message handler: $e');
      rethrow;
    }
  }

  /// Register a callback for received messages
  void onMessageReceived(Function(String) callback) {
    js.context['flutterMessageReceived'] = (String message) {
      callback(message);
    };
  }
}
