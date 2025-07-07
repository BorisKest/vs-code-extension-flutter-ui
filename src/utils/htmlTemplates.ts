export function getPlaceholderContent(): string {
    return `<!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Flutter Web Extension UI</title>
        <style>
            body {
                margin: 0;
                padding: 20px;
                background-color: #1e1e1e;
                color: #cccccc;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }
            .container {
                max-width: 600px;
                margin: 0 auto;
                text-align: center;
                padding: 40px 20px;
            }
            .title {
                color: #007acc;
                font-size: 24px;
                margin-bottom: 16px;
            }
            .subtitle {
                font-size: 16px;
                margin-bottom: 24px;
                opacity: 0.8;
            }
            .instructions {
                background-color: #2d2d30;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: left;
            }
            .code {
                background-color: #1e1e1e;
                padding: 12px;
                border-radius: 4px;
                font-family: 'Courier New', monospace;
                font-size: 14px;
                margin: 8px 0;
                border: 1px solid #3e3e42;
            }
            .note {
                background-color: #2d2d30;
                padding: 16px;
                border-radius: 8px;
                border-left: 4px solid #007acc;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="title">🚀 Flutter Web Extension UI</h1>
            <p class="subtitle">Building the Flutter web app...</p>
            
            <div class="instructions">
                <h3>To build the Flutter UI:</h3>
                <ol>
                    <li>Open a terminal in the extension directory</li>
                    <li>Navigate to the flutter_ui folder:</li>
                    <div class="code">cd flutter_ui</div>
                    <li>Get Flutter dependencies:</li>
                    <div class="code">flutter pub get</div>
                    <li>Build the web app:</li>
                    <div class="code">flutter build web --release</div>
                    <li>Reload this extension window</li>
                </ol>
            </div>
            
            <div class="note">
                <strong>Note:</strong> Make sure you have Flutter installed and the web support enabled.
                Run <code>flutter config --enable-web</code> if needed.
            </div>
        </div>
    </body>
    </html>`;
}

export function getErrorContent(errorMessage: string): string {
    return `<!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Flutter Load Error</title>
        <style>
            body {
                margin: 0;
                padding: 20px;
                background-color: #1e1e1e;
                color: #ff6b6b;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                text-align: center;
            }
            .error-container {
                max-width: 500px;
            }
            h1 {
                color: #ff6b6b;
                margin-bottom: 16px;
            }
            p {
                margin-bottom: 16px;
                line-height: 1.5;
            }
            .suggestion {
                background-color: #2d2d30;
                padding: 16px;
                border-radius: 8px;
                border-left: 4px solid #ff6b6b;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <h1>Flutter Loading Error</h1>
            <p>${errorMessage}</p>
            <div class="suggestion">
                <strong>Try:</strong><br>
                1. Rebuild Flutter: <code>flutter build web --release</code><br>
                2. Reload this webview panel<br>
                3. Check the Developer Console for more details
            </div>
        </div>
    </body>
    </html>`;
}
