import 'package:bynextcourier/constants.dart';
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget{
  final Widget child;
  final condition;
  final onHorizontalDragUpdate;

  const AnimatedButton({Key key, this.child, this.onHorizontalDragUpdate, this.condition}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  List<Color> _colors = List<Color>.generate(
    4, (index) => index.isOdd ? Colors.transparent
    :raisedButtonColor);
  List<double> _stops = List<double>.generate(4,
      (index) => index * 0.2 - 0.8);

  @override
  void initState() {
    controller =
      AnimationController(vsync: this,
        duration: Duration(milliseconds: 2000));

    animation = Tween<double>(begin: 0.0, end: 1.6).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    super.initState();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      child: Stack(
        children: <Widget>[
          IgnorePointer(
            child: RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  widget.child,
                ],
              ),
              onPressed: widget.condition ? (){} : null,
            ),
          ),
          widget.condition ? Container(
            height: 42,
            child: GestureDetector(
              onHorizontalDragUpdate: widget.condition ? widget.onHorizontalDragUpdate : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _colors,
                          stops: _stops.map((s) => s + animation.value).toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}