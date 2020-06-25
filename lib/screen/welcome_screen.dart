import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/bloc/profile_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight - 14,
              ),
              child: IntrinsicHeight(
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(mediaUrl + (profileState.profile?.profilePhotoUrl ?? "")),
                            backgroundColor: Colors.brown.shade800,
                            child: profileState.profile?.profilePhotoUrl == null ? Text('AH') : null,
                            radius: 44,
                          ),
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Text('Hey ${profileState.profile?.firstName ?? ''}',
                                style: Theme.of(context).textTheme.headline2)),
                        const SizedBox(
                          height: 36,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(9.0),
                                  child: Text(
                                    'Next Location',
                                    textAlign: TextAlign.center,
                                  )),
                              Divider(),
                              Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(9.0),
                                      child: Text(
                                        '100 W 84TH ST NEW YORK 10024',
                                      )),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      height: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Image.asset('assets/images/navigation-icon.png'),
                                        iconSize: 30,
                                        onPressed: () {
                                          launchMaps(40.785101, -73.9738665999);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(9.0), child: Text('Start Time')),
                              Divider(),
                              Padding(padding: EdgeInsets.all(9.0), child: Text('11/2/15 - 5:45 PM')),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(9.0), child: Text('Dispatcher')),
                              Divider(),
                              Padding(padding: EdgeInsets.all(9.0), child: Text('Bart Simpson')),
                            ],
                          ),
                        ),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.headline3,
                                  children: [
                                    TextSpan(text: 'Estimated Earnings: ', style: TextStyle(fontWeight: FontWeight.w400)),
                                    TextSpan(text: '\$16.10', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ]
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                iconSize: 50,
                                icon: Image.asset('assets/images/piggy-bank.png'),
                                onPressed: () {
                                  _player.stop();
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
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
