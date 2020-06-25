import 'dart:math';

import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  final String text;

  const CustomProgressIndicator({Key key, this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50000),
      vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: RotationTransition(
                turns: Tween(begin: -pi / 2, end: 20 * pi + pi / 2).animate(_controller),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: SweepGradient(
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black87, // Theme.of(context).colorScheme.primaryVariant,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            widget.text != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                : Container(
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
