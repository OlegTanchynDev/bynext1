import 'package:flutter/material.dart';

class CustomTab extends Tab {
  final double tabHeight;

  const CustomTab(this.tabHeight, {
    Key key,
    child,
  }):super(key: key, child: child);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tabHeight,
      child: Center(
        child: this.child,
        widthFactor: 1.0,
      ),
    );
  }
}
