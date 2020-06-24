import 'dart:async';
import 'dart:convert';

import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({Key key, this.url, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _loading = true;
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _loading,
            child: WebView(
              initialUrl: 'about:blank',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                _controller.loadUrl(Uri.dataFromString('<html><body style="background-color: $colorStr"></body></html>',
                        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                    .toString());
              },
              onPageFinished: (String url) {
                if (url.startsWith('data:')) {
                  _controller.loadUrl(widget.url);
                } else if (url.startsWith('http')) {
                  setState(() {
                    _loading = false;
                  });
                }
              },
              gestureNavigationEnabled: true,
            ),
          ),
          _loading ? CustomProgressIndicator() : Container()
        ],
      ),
    );
  }

  String get colorStr {
    var color = Theme.of(context).scaffoldBackgroundColor;
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
  }
}
