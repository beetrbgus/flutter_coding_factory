import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BlogHomeScreen extends StatelessWidget {
  BlogHomeScreen({super.key});
  WebViewController webViewController = WebViewController()
    ..loadRequest(Uri.parse('https://blog.codefactory.ai'))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('호호'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              webViewController
                  .loadRequest(Uri.parse('https://blog.codefactory.ai'));
            },
            icon: const Icon(
              Icons.home,
            ),
          ),
        ],
      ),
      body: Container(
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}
