/// Represents a message between Flutter and VS Code extension
class ExtensionMessage {
  final String type;
  final String message;
  final DateTime timestamp;

  ExtensionMessage({
    required this.type,
    required this.message,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ExtensionMessage.fromJson(Map<String, dynamic> json) {
    return ExtensionMessage(
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ExtensionMessage(type: $type, message: $message, timestamp: $timestamp)';
  }
}
