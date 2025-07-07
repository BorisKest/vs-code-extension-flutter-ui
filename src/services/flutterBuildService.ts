import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

export class FlutterBuildService {
    private static instance: FlutterBuildService;
    
    private constructor() {}
    
    static getInstance(): FlutterBuildService {
        if (!FlutterBuildService.instance) {
            FlutterBuildService.instance = new FlutterBuildService();
        }
        return FlutterBuildService.instance;
    }

    /**
     * Check if Flutter build exists
     */
    checkBuildExists(context: vscode.ExtensionContext): boolean {
        const flutterBuildPath = path.join(context.extensionPath, 'flutter_ui', 'build', 'web');
        const indexPath = path.join(flutterBuildPath, 'index.html');
        return fs.existsSync(indexPath);
    }

    /**
     * Get Flutter build debug information
     */
    getBuildInfo(context: vscode.ExtensionContext): string {
        const flutterBuildPath = path.join(context.extensionPath, 'flutter_ui', 'build', 'web');
        const indexPath = path.join(flutterBuildPath, 'index.html');
        const mainJsPath = path.join(flutterBuildPath, 'main.dart.js');
        const flutterJsPath = path.join(flutterBuildPath, 'flutter.js');
        
        let debugInfo = 'Flutter Build Debug Info:\\n';
        debugInfo += `Build path exists: ${fs.existsSync(flutterBuildPath)}\\n`;
        debugInfo += `index.html exists: ${fs.existsSync(indexPath)}\\n`;
        debugInfo += `main.dart.js exists: ${fs.existsSync(mainJsPath)}\\n`;
        debugInfo += `flutter.js exists: ${fs.existsSync(flutterJsPath)}\\n`;
        
        if (fs.existsSync(flutterBuildPath)) {
            const files = fs.readdirSync(flutterBuildPath);
            debugInfo += `Files in build/web: ${files.join(', ')}\\n`;
        }
        
        return debugInfo;
    }

    /**
     * Get Flutter web content with proper webview URI conversion
     */
    getFlutterWebContent(webview: vscode.Webview, context: vscode.ExtensionContext): string {
        const flutterBuildPath = vscode.Uri.joinPath(context.extensionUri, 'flutter_ui', 'build', 'web');
        
        try {
            const indexPath = path.join(context.extensionPath, 'flutter_ui', 'build', 'web', 'index.html');
            let indexContent = fs.readFileSync(indexPath, 'utf8');
            
            // Replace relative paths with webview URIs
            const flutterJsUri = webview.asWebviewUri(vscode.Uri.joinPath(flutterBuildPath, 'flutter.js'));
            const manifestUri = webview.asWebviewUri(vscode.Uri.joinPath(flutterBuildPath, 'manifest.json'));
            const faviconUri = webview.asWebviewUri(vscode.Uri.joinPath(flutterBuildPath, 'favicon.png'));
            
            // Apply replacements and add VS Code specific scripts and styles
            indexContent = this.applyWebviewReplacements(indexContent, webview, flutterBuildPath, {
                flutterJsUri,
                manifestUri,
                faviconUri
            });
            
            return indexContent;
            
        } catch (error) {
            console.error('Error reading Flutter index.html:', error);
            throw new Error(`Failed to load Flutter index.html: ${error}`);
        }
    }

    private applyWebviewReplacements(
        content: string, 
        webview: vscode.Webview, 
        flutterBuildPath: vscode.Uri,
        uris: { flutterJsUri: vscode.Uri, manifestUri: vscode.Uri, faviconUri: vscode.Uri }
    ): string {
        return content
            .replace('href="/"', `href="${webview.asWebviewUri(flutterBuildPath)}/"`)
            .replace('src="flutter.js"', `src="${uris.flutterJsUri}"`)
            .replace('href="manifest.json"', `href="${uris.manifestUri}"`)
            .replace('href="favicon.png"', `href="${uris.faviconUri}"`)
            .replace('href="icons/Icon-192.png"', `href="${webview.asWebviewUri(vscode.Uri.joinPath(flutterBuildPath, 'icons', 'Icon-192.png'))}"`)
            // Add VS Code webview API and custom styling
            .replace('<head>', `<head>
            <script>
                // VS Code webview API
                const vscode = acquireVsCodeApi();
                console.log('VS Code API acquired successfully');
                
                // Make VS Code API globally available
                window.vscode = vscode;
            </script>
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    background-color: #1e1e1e;
                    overflow: hidden;
                }
                #loading {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: #1e1e1e;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    color: #cccccc;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    z-index: 9999;
                }
                .spinner {
                    border: 2px solid #3c3c3c;
                    border-top: 2px solid #007acc;
                    border-radius: 50%;
                    width: 24px;
                    height: 24px;
                    animation: spin 1s linear infinite;
                    margin-bottom: 16px;
                }
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            </style>`)
            // Add loading overlay
            .replace('<body>', `<body>
            <div id="loading">
                <div class="spinner"></div>
                <div>Loading Flutter UI...</div>
            </div>`)
            // Modify the Flutter loading script to hide loading overlay
            .replace('appRunner.runApp();', `appRunner.runApp();
                        const loading = document.getElementById('loading');
                        if (loading) {
                            loading.style.display = 'none';
                        }
                        console.log('Flutter app loaded successfully in VS Code webview');`);
    }
}
