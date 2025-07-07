import 'package:flutter/foundation.dart';
import '../../data/vscode_service.dart';
import '../../domain/models/extension_command.dart';
import '../../domain/models/extension_message.dart';

/// Provider for managing extension communication state
class ExtensionProvider with ChangeNotifier {
  final VSCodeService _vsCodeService = VSCodeService.instance;

  String _currentMessage = 'Flutter UI loaded in VS Code extension!';
  bool _isInitialized = false;
  List<ExtensionMessage> _messageHistory = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  String get currentMessage => _currentMessage;
  bool get isInitialized => _isInitialized;
  List<ExtensionMessage> get messageHistory =>
      List.unmodifiable(_messageHistory);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize the provider and VS Code service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _setLoading(true);
    _clearError();

    try {
      await _vsCodeService.initialize();
      _vsCodeService.onMessageReceived(_handleReceivedMessage);
      _isInitialized = true;
      _addToHistory(ExtensionMessage(
        type: 'system',
        message: 'Extension provider initialized successfully',
      ));
    } catch (e) {
      _setError('Failed to initialize extension provider: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Send a text message to the extension
  Future<void> sendMessage(String message) async {
    if (!_isInitialized) {
      _setError('Provider not initialized');
      return;
    }

    _clearError();

    try {
      await _vsCodeService.sendMessage(message);
      _addToHistory(ExtensionMessage(
        type: 'sent',
        message: message,
      ));
    } catch (e) {
      _setError('Failed to send message: $e');
    }
  }

  /// Send a command to the extension
  Future<void> sendCommand(ExtensionCommand command) async {
    if (!_isInitialized) {
      _setError('Provider not initialized');
      return;
    }

    _clearError();

    try {
      await _vsCodeService.sendCommand(command);
      _addToHistory(ExtensionMessage(
        type: 'command',
        message: 'Sent command: ${command.action}',
      ));
    } catch (e) {
      _setError('Failed to send command: $e');
    }
  }

  /// Handle received message from extension
  void _handleReceivedMessage(String message) {
    _currentMessage = message;
    _addToHistory(ExtensionMessage(
      type: 'received',
      message: message,
    ));
    notifyListeners();
  }

  /// Add message to history
  void _addToHistory(ExtensionMessage message) {
    _messageHistory.add(message);
    // Keep only last 50 messages
    if (_messageHistory.length > 50) {
      _messageHistory.removeAt(0);
    }
    notifyListeners();
  }

  /// Clear message history
  void clearHistory() {
    _messageHistory.clear();
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
