import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'core/theme.dart';
import 'core/constants.dart';
import 'presentation/providers/extension_provider.dart';
import 'presentation/pages/extension_page.dart';

void main() {
  // CRITICAL: Prevent Flutter from trying to use browser history API in webview
  // This must be called BEFORE runApp() to prevent SecurityErrors
  _preventHistoryManipulation();
  runApp(const VSCodeExtensionApp());
}

/// Prevent Flutter from trying to use browser history API in webview
void _preventHistoryManipulation() {
  try {
    js.context.callMethod('eval', [
      '''
      (function() {
        console.log('Installing history API overrides for VS Code webview...');
        
        const originalPushState = window.history.pushState;
        const originalReplaceState = window.history.replaceState;
        const originalGo = window.history.go;
        const originalBack = window.history.back;
        const originalForward = window.history.forward;
        
        window.history.pushState = function(state, title, url) {
          console.log('Prevented pushState call in VS Code webview');
          return;
        };
        
        window.history.replaceState = function(state, title, url) {
          console.log('Prevented replaceState call in VS Code webview');
          return;
        };
        
        window.history.go = function(delta) {
          console.log('Prevented history.go call in VS Code webview');
          return;
        };
        
        window.history.back = function() {
          console.log('Prevented history.back call in VS Code webview');
          return;
        };
        
        window.history.forward = function() {
          console.log('Prevented history.forward call in VS Code webview');
          return;
        };
        
        console.log('History API overrides installed successfully for VS Code webview');
      })();
      '''
    ]);
  } catch (e) {
    print('Failed to override history API: $e');
  }
}

class VSCodeExtensionApp extends StatelessWidget {
  const VSCodeExtensionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExtensionProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        theme: AppTheme.darkTheme,
        home: const ExtensionPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
