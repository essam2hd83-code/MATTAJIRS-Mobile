
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Nécessaire pour Android WebView.
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebView();
  }
  runApp(const MattajirsApp());
}

class MattajirsApp extends StatelessWidget {
  const MattajirsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mattajirs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4A2A)), // TODO: ajuster au marron du logo
        useMaterial3: true,
      ),
      home: const MattajirsHome(),
    );
  }
}

class MattajirsHome extends StatefulWidget {
  const MattajirsHome({super.key});

  @override
  State<MattajirsHome> createState() => _MattajirsHomeState();
}

class _MattajirsHomeState extends State<MattajirsHome> {
  final tabs = const [
    _TabSpec('Accueil', Icons.home_outlined, 'https://mattajirs.com/'),
    _TabSpec('Boutique', Icons.storefront_outlined, 'https://mattajirs.com/boutique/'),
    _TabSpec('Panier', Icons.shopping_cart_outlined, 'https://mattajirs.com/panier/'),
    _TabSpec('Compte', Icons.person_outline, 'https://mattajirs.com/mon-compte/'),
  ];

  int _currentIndex = 0;
  final _controllers = <int, WebViewController>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < tabs.length; i++) {
      _controllers[i] = _buildController(tabs[i].url);
    }
  }

  WebViewController _buildController(String url) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            // Ouvrir les liens externes en dehors du WebView.
            if (!_isMattajirsUrl(uri)) {
              _launchExternal(uri);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    return controller;
  }

  bool _isMattajirsUrl(Uri uri) {
    final host = uri.host.toLowerCase();
    return host.endsWith('mattajirs.com');
  }

  Future<void> _launchExternal(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _reload() async {
    final c = _controllers[_currentIndex];
    if (c != null) {
      await c.reload();
    }
  }

  Future<bool> _handleWillPop() async {
    final c = _controllers[_currentIndex];
    if (c != null && await c.canGoBack()) {
      await c.goBack();
      return false;
    }
    return true; // quitter l'app
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controllers[_currentIndex]!;

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mattajirs'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _reload,
              child: WebViewWidget(controller: controller),
            ),
            if (_isLoading)
              const LinearProgressIndicator(minHeight: 2),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: [
            for (final t in tabs) NavigationDestination(icon: Icon(t.icon), label: t.label),
          ],
        ),
      ),
    );
  }
}

class _TabSpec {
  final String label;
  final IconData icon;
  final String url;
  const _TabSpec(this.label, this.icon, this.url);
}
