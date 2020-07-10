import 'dart:ffi';

import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget{
  final Widget child;
  final onPressed;
  final onHorizontalDragUpdate;

  const AnimatedButton({Key key, this.child, this.onHorizontalDragUpdate, this.onPressed}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
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
              onPressed: widget.onPressed,
            ),
          ),
          Container(
            height: 42,
            child: GestureDetector(
              onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 42,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}