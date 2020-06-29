import 'dart:convert';

import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final bool shouldSignContract;

  const WebViewScreen({Key key, this.url, this.title, this.shouldSignContract}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _loading = true;
  WebViewController _controller;

  List<Widget> actions(BuildContext context) {
    var declineButton = FlatButton(
//      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      child: Text('Decline'),
      onPressed: () async {
        await showCustomDialog(
          context,
          title: 'Contract declined',
          message: 'You must accept your contract inorder to begin you shift. You will now be logged out.',
          buttons: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
        Navigator.of(context).pop();
        BlocProvider.of<TokenBloc>(context).add(ClearToken());
      },
    );
    var title = Text(widget.title);
    var acceptButton = FlatButton(
      child: Text('Accept'),
      onPressed: () {},
    );
    return widget.shouldSignContract
        ? <Widget>[declineButton, Expanded(child: Center(child: title)), acceptButton]
        : <Widget>[const SizedBox(width: 50)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.shouldSignContract ? null : Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: !widget.shouldSignContract,
        actions: actions(context),
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
