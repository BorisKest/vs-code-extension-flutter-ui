import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/extension_provider.dart';
import '../widgets/extension_header.dart';
import '../widgets/vscode_card.dart';
import '../widgets/message_display.dart';
import '../widgets/feature_button.dart';
import '../../domain/models/extension_command.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

/// Main extension UI page
class ExtensionPage extends StatefulWidget {
  const ExtensionPage({super.key});

  @override
  State<ExtensionPage> createState() => _ExtensionPageState();
}

class _ExtensionPageState extends State<ExtensionPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _terminalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the provider when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExtensionProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _terminalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExtensionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.isInitialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                  SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'Initializing Extension...',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const ExtensionHeader(),

                const SizedBox(height: AppConstants.largePadding),

                // Error Display
                if (provider.error != null)
                  VSCodeCard(
                    title: 'Error',
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppTheme.errorColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppTheme.errorColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.error!,
                              style: const TextStyle(
                                color: AppTheme.errorColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Message Display
                VSCodeCard(
                  title: 'Latest Message from Extension',
                  child: MessageDisplay(
                    title: '',
                    message: provider.currentMessage,
                  ),
                ),

                // Send Message Section
                VSCodeCard(
                  title: 'Send Message to Extension',
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                          ),
                          onSubmitted: (value) => _sendMessage(provider, value),
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _sendMessage(provider, _messageController.text),
                        icon: const Icon(Icons.send,
                            size: AppConstants.smallIconSize),
                        label: const Text('Send'),
                      ),
                    ],
                  ),
                ),

                // Quick Actions
                VSCodeCard(
                  title: 'Quick Actions',
                  child: Wrap(
                    spacing: AppConstants.smallPadding,
                    runSpacing: AppConstants.smallPadding,
                    children: [
                      FeatureButton(
                        label: 'Open File',
                        icon: Icons.folder_open,
                        onPressed: () =>
                            provider.sendCommand(ExtensionCommand.openFile()),
                      ),
                      FeatureButton(
                        label: 'Show Message',
                        icon: Icons.message,
                        onPressed: () => provider.sendCommand(
                          ExtensionCommand.showMessage('Hello from Flutter!'),
                        ),
                      ),
                      FeatureButton(
                        label: 'Get Workspace',
                        icon: Icons.work,
                        onPressed: () => provider
                            .sendCommand(ExtensionCommand.getWorkspace()),
                      ),
                      FeatureButton(
                        label: 'Create File',
                        icon: Icons.note_add,
                        onPressed: () =>
                            provider.sendCommand(ExtensionCommand.createFile()),
                      ),
                    ],
                  ),
                ),

                // Terminal Command Section
                VSCodeCard(
                  title: 'Run Terminal Command',
                  child: Column(
                    children: [
                      TextField(
                        controller: _terminalController,
                        decoration: const InputDecoration(
                          hintText:
                              'Enter terminal command (e.g., "ls", "git status")...',
                          prefixIcon: Icon(Icons.terminal,
                              color: AppTheme.textSecondary),
                        ),
                        onSubmitted: (value) =>
                            _runTerminalCommand(provider, value),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _runTerminalCommand(
                              provider,
                              _terminalController.text,
                            ),
                            icon: const Icon(Icons.play_arrow,
                                size: AppConstants.smallIconSize),
                            label: const Text('Run Command'),
                          ),
                          const SizedBox(width: AppConstants.smallPadding),
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              children: [
                                _buildQuickCommandChip(provider, 'git status'),
                                _buildQuickCommandChip(provider, 'npm list'),
                                _buildQuickCommandChip(
                                    provider, 'flutter doctor'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Message History
                if (provider.messageHistory.isNotEmpty)
                  VSCodeCard(
                    title: 'Message History',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${provider.messageHistory.length} messages',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextButton.icon(
                              onPressed: provider.clearHistory,
                              icon: const Icon(Icons.clear_all, size: 16),
                              label: const Text('Clear',
                                  style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.textSecondary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: provider.messageHistory.length,
                            itemBuilder: (context, index) {
                              final message = provider.messageHistory.reversed
                                  .elementAt(index);
                              return _buildHistoryItem(message);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(ExtensionProvider provider, String message) {
    if (message.trim().isNotEmpty) {
      provider.sendMessage(message.trim());
      _messageController.clear();
    }
  }

  void _runTerminalCommand(ExtensionProvider provider, String command) {
    if (command.trim().isNotEmpty) {
      provider.sendCommand(ExtensionCommand.runTerminalCommand(command.trim()));
      _terminalController.clear();
    }
  }

  Widget _buildQuickCommandChip(ExtensionProvider provider, String command) {
    return ActionChip(
      label: Text(
        command,
        style: const TextStyle(fontSize: 10),
      ),
      onPressed: () => _runTerminalCommand(provider, command),
      backgroundColor: AppTheme.backgroundColor,
      side: const BorderSide(color: AppTheme.borderColor),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildHistoryItem(dynamic message) {
    IconData icon;
    Color color;

    switch (message.type) {
      case 'sent':
        icon = Icons.arrow_upward;
        color = AppTheme.primaryColor;
        break;
      case 'received':
        icon = Icons.arrow_downward;
        color = AppTheme.successColor;
        break;
      case 'command':
        icon = Icons.bolt;
        color = AppTheme.warningColor;
        break;
      default:
        icon = Icons.info;
        color = AppTheme.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontFamily: 'Consolas, monospace',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
