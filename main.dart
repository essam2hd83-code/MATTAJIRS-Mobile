import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mattajirs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MattajirsWebView(),
    );
  }
}

class MattajirsWebView extends StatefulWidget {
  const MattajirsWebView({super.key});

  @override
  State<MattajirsWebView> createState() => _MattajirsWebViewState();
}

class _MattajirsWebViewState extends State<MattajirsWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://mattajirs.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}