import * as vscode from 'vscode';
import { FlutterCommand, ExtensionResponse } from '../models/types';

export class CommandService {
    private static instance: CommandService;
    private currentPanel: vscode.WebviewPanel | undefined;
    
    private constructor() {}
    
    static getInstance(): CommandService {
        if (!CommandService.instance) {
            CommandService.instance = new CommandService();
        }
        return CommandService.instance;
    }

    setCurrentPanel(panel: vscode.WebviewPanel | undefined) {
        this.currentPanel = panel;
    }

    /**
     * Handle Flutter command
     */
    async handleFlutterCommand(command: FlutterCommand): Promise<void> {
        try {
            console.log('Handling Flutter command:', command);
            
            switch (command.action) {
                case 'openFile':
                    await this.handleOpenFile();
                    break;
                
                case 'showMessage':
                    await this.handleShowMessage(command.text || 'Hello from Flutter!');
                    break;
                
                case 'getWorkspace':
                    await this.handleGetWorkspace();
                    break;
                
                case 'createFile':
                    await this.handleCreateFile();
                    break;
                
                case 'runTerminalCommand':
                    await this.handleRunTerminalCommand(command.command || '');
                    break;
                
                default:
                    console.log('Unknown command from Flutter:', command);
                    this.sendResponse({
                        type: 'error',
                        message: `Unknown command: ${command.action}`
                    });
            }
        } catch (error: any) {
            console.error('Error handling Flutter command:', error);
            this.sendResponse({
                type: 'error',
                message: `Error handling command: ${error.message}`
            });
        }
    }

    private async handleOpenFile(): Promise<void> {
        await vscode.commands.executeCommand('workbench.action.files.openFile');
        this.sendResponse({
            type: 'info',
            message: 'Open file dialog triggered'
        });
    }

    private async handleShowMessage(text: string): Promise<void> {
        vscode.window.showInformationMessage(text);
        this.sendResponse({
            type: 'info',
            message: `Message shown: ${text}`
        });
    }

    private async handleGetWorkspace(): Promise<void> {
        const workspaceName = vscode.workspace.name || 'No workspace';
        const workspaceFolders = vscode.workspace.workspaceFolders?.map(folder => folder.name) || [];
        
        this.sendResponse({
            type: 'fromExtension',
            message: `Current workspace: ${workspaceName}`,
            data: {
                name: workspaceName,
                folders: workspaceFolders
            }
        });
    }

    private async handleCreateFile(): Promise<void> {
        await vscode.commands.executeCommand('workbench.action.files.newUntitledFile');
        this.sendResponse({
            type: 'info',
            message: 'New file created'
        });
    }

    private async handleRunTerminalCommand(command: string): Promise<void> {
        if (!command.trim()) {
            this.sendResponse({
                type: 'error',
                message: 'No command provided'
            });
            return;
        }

        try {
            // Create a new terminal and run the command
            const terminal = vscode.window.createTerminal('Flutter Extension');
            terminal.sendText(command);
            terminal.show();
            
            this.sendResponse({
                type: 'info',
                message: `Terminal command executed: ${command}`
            });
        } catch (error: any) {
            this.sendResponse({
                type: 'error',
                message: `Failed to run terminal command: ${error.message}`
            });
        }
    }

    private sendResponse(response: ExtensionResponse): void {
        if (this.currentPanel) {
            this.currentPanel.webview.postMessage(response);
        }
    }
}
