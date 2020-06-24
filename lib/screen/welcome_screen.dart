import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:just_audio/just_audio.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    _player.setAsset('assets/audio/quiet_pig.mp3').catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[
          HiddenDrawerIcon(),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text('Welcome', style: Theme.of(context).textTheme.headline2)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        child: Text('AH'),
                        radius: 44,
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text('Hey John', style: Theme.of(context).textTheme.headline2)),
                    const Expanded(
                      child: const SizedBox(
                        height: 0,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Estimated Earnings:'),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('\$16.10'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            iconSize: 50,
                            icon: Image.asset('assets/images/piggy-bank.png'),
                            onPressed: () {
                              _player.play();
                            },
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      child: Text('Start Job'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
