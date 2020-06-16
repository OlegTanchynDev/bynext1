import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum HiddenDrawerPosition { left, right }

class HiddenDrawer extends StatefulWidget {
  HiddenDrawer(
      {@required this.child,
      @required this.drawer,
      this.drawerBlurRadius = 12,
      this.drawerWidth = 250,
      this.drawerHeaderHeight = 250,
      this.drawerPosition = HiddenDrawerPosition.left,
      this.openScale = 1.0,
      Key key})
      : assert(child != null),
        assert(drawer != null),
        super(key: key);

  final Widget child;

  /// Hidden drawer widget that will build your drawer,
  /// you should use HiddenDrawerMenu for more user experience
  final Widget drawer;

  final double drawerWidth;

  final double drawerHeaderHeight;

  final double drawerBlurRadius;

  final HiddenDrawerPosition drawerPosition;

  final double openScale;

  @override
  HiddenDrawerState createState() => HiddenDrawerState();

  static HiddenDrawerState of(BuildContext context) {
    assert(context != null);
    final HiddenDrawerState result = context.findAncestorStateOfType();
    if (result != null) return result;
    throw FlutterError('HiddenDrawer.of() called with a context that does not contain a HiddenDrawer.');
  }
}

class HiddenDrawerState extends State<HiddenDrawer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scale;
  Animation<double> _offset;
  Animation<double> _blur;
  bool _drawerState = false;

  bool get isDrawerOpen => _drawerState;

  double get drawerWidth => widget.drawerWidth * 1.2;

  double get drawerHeaderHeight => widget.drawerHeaderHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scale = Tween<double>(begin: 1, end: widget.openScale).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _offset = Tween<double>(begin: 0, end: widget.drawerWidth).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _blur = Tween<double>(begin: 0, end: widget.drawerBlurRadius).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Positioned(
          left: (widget.drawerPosition == HiddenDrawerPosition.left ? 0 : width - widget.drawerWidth),
          child: widget.drawer,
        ),
        Positioned(
          left: (widget.drawerPosition == HiddenDrawerPosition.left ? 1 : -1) * _offset.value,
          right: (widget.drawerPosition == HiddenDrawerPosition.left ? -1 : 1) * _offset.value,
          child: Transform.scale(
            scale: _scale.value,
            child: SizedBox(
              width: width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onHorizontalDragUpdate: _move,
                onHorizontalDragEnd: _settle,
                dragStartBehavior: DragStartBehavior.start,
                onTap: _tapOnChild,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(blurRadius: _blur.value)],
                      ),
                      child: widget.child,
                    ),
                    isDrawerOpen
                        ? Container(
                            width: width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.transparent,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _move(DragUpdateDetails details) {
    if (Navigator.of(context).canPop()) {
    } else {
      double delta = details.primaryDelta / MediaQuery.of(context).size.width;
      switch (widget.drawerPosition) {
        case HiddenDrawerPosition.right:
          _controller.value -= delta;
          break;
        case HiddenDrawerPosition.left:
          _controller.value += delta;
          break;
      }
    }
  }

  void _settle(DragEndDetails details) {
    if (Navigator.of(context).canPop()) {
    } else {
      if (_controller.isDismissed) return;
      if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
        double visualVelocity = details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
        setState(() {
          _drawerState = (widget.drawerPosition == HiddenDrawerPosition.left ? 1 : -1) * visualVelocity > 0;
        });
        switch (widget.drawerPosition) {
          case HiddenDrawerPosition.right:
            _controller.fling(velocity: -visualVelocity);
            break;
          case HiddenDrawerPosition.left:
            _controller.fling(velocity: visualVelocity);
            break;
        }
      } else if (_controller.value < 0.5) {
        _close();
      } else {
        _open();
      }
    }
  }

  void _open() {
    _controller.fling(velocity: widget.drawerPosition == HiddenDrawerPosition.left ? -1.0 : 1.0);
    setState(() {
      _drawerState = true;
    });
  }

  void _close() {
    _controller.fling(velocity: widget.drawerPosition == HiddenDrawerPosition.left ? 1.0 : -1.0);
    setState(() {
      _drawerState = false;
    });
  }

  void _tapOnChild() {
    if (_drawerState) {
      _close();
    }
  }

  void handleDrawer() {
    if (_drawerState) {
      _close();
    } else {
      _open();
    }
  }
}
