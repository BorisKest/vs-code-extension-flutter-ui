// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import { FlutterBuildService } from './services/flutterBuildService';
import { CommandService } from './services/commandService';
import { FlutterMessage, FlutterCommand } from './models/types';
import { getPlaceholderContent, getErrorContent } from './utils/htmlTemplates';

let currentPanel: vscode.WebviewPanel | undefined = undefined;

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
	console.log('Flutter Web Extension is now active!');

	const flutterBuildService = FlutterBuildService.getInstance();
	const commandService = CommandService.getInstance();

	// Register command to open Flutter UI
	const openFlutterUI = vscode.commands.registerCommand('extension.openFlutterUI', () => {
		createOrShowFlutterPanel(context, flutterBuildService, commandService);
	});

	// Register the original hello world command
	const helloWorld = vscode.commands.registerCommand('extension.helloWorld', () => {
		vscode.window.showInformationMessage('Hello World from Flutter Web Extension!');
		
		// Also send message to Flutter UI if it's open
		if (currentPanel) {
			currentPanel.webview.postMessage({
				type: 'fromExtension',
				message: 'Hello from VS Code Extension!'
			});
		}
	});

	// Register debugging command
	const debugFlutter = vscode.commands.registerCommand('extension.debugFlutter', () => {
		const debugInfo = flutterBuildService.getBuildInfo(context);
		vscode.window.showInformationMessage(debugInfo, { modal: true });
	});

	context.subscriptions.push(openFlutterUI, helloWorld, debugFlutter);
}

function createOrShowFlutterPanel(
	context: vscode.ExtensionContext,
	flutterBuildService: FlutterBuildService,
	commandService: CommandService
) {
	const columnToShowIn = vscode.window.activeTextEditor
		? vscode.window.activeTextEditor.viewColumn
		: undefined;

	// If we already have a panel, show it.
	if (currentPanel) {
		currentPanel.reveal(columnToShowIn);
		return;
	}

	// Otherwise, create a new panel.
	currentPanel = vscode.window.createWebviewPanel(
		'flutterWebUI',
		'Flutter Web UI',
		columnToShowIn || vscode.ViewColumn.One,
		{
			// Enable scripts in the webview
			enableScripts: true,
			
			// And restrict the webview to only loading content from our extension's directory.
			localResourceRoots: [
				vscode.Uri.joinPath(context.extensionUri, 'flutter_ui', 'build', 'web')
			],
			
			// Retain context when hidden
			retainContextWhenHidden: true
		}
	);

	// Set the webview's initial html content
	currentPanel.webview.html = getWebviewContent(currentPanel.webview, context, flutterBuildService);

	// Set up command service with current panel
	commandService.setCurrentPanel(currentPanel);

	// Handle messages from the webview
	currentPanel.webview.onDidReceiveMessage(
		async (message: FlutterMessage) => {
			try {
				console.log('Received message from Flutter:', message);
				
				switch (message.type) {
					case 'fromFlutter':
						// Show notification for regular messages
						vscode.window.showInformationMessage(`Flutter says: ${message.message}`);
						
						// Try to parse as JSON for commands
						try {
							const command: FlutterCommand = JSON.parse(message.message);
							await commandService.handleFlutterCommand(command);
						} catch {
							// Not a JSON command, just a regular message
							console.log('Received regular message from Flutter:', message.message);
						}
						break;
					
					default:
						console.log('Unknown message type from Flutter:', message.type);
				}
			} catch (error: any) {
				console.error('Error processing message from Flutter:', error);
				if (currentPanel) {
					currentPanel.webview.postMessage({
						type: 'error',
						message: `Error processing message: ${error.message}`
					});
				}
			}
		},
		undefined,
		context.subscriptions
	);

	// Reset when the current panel is closed
	currentPanel.onDidDispose(
		() => {
			currentPanel = undefined;
			commandService.setCurrentPanel(undefined);
		},
		null,
		context.subscriptions
	);
}

function getWebviewContent(
	webview: vscode.Webview, 
	context: vscode.ExtensionContext, 
	flutterBuildService: FlutterBuildService
): string {
	// Check if Flutter build exists
	if (flutterBuildService.checkBuildExists(context)) {
		try {
			// Load the built Flutter web app
			return flutterBuildService.getFlutterWebContent(webview, context);
		} catch (error) {
			console.error('Error loading Flutter web content:', error);
			return getErrorContent(`Failed to load Flutter web content: ${error}`);
		}
	} else {
		// Show a placeholder with build instructions
		return getPlaceholderContent();
	}
}

// This method is called when your extension is deactivated
export function deactivate() {
	if (currentPanel) {
		currentPanel.dispose();
	}
}
