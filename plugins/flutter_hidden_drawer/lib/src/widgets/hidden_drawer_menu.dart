import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:flutter_hidden_drawer/src/providers/drawer_menu_state.dart';
import 'package:provider/provider.dart';

class HiddenDrawerMenu extends StatelessWidget {
  HiddenDrawerMenu(
      {this.header,
      this.footer,
      @required this.menu,
      this.menuColor = Colors.transparent,
      this.menuActiveColor = Colors.blue,
      this.drawerDecoration})
      : assert(menu != null || menu.length > 0);

  final Widget header;
  final Widget footer;
  final List<DrawerMenu> menu;
  final Color menuColor;
  final Color menuActiveColor;
  final BoxDecoration drawerDecoration;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final DrawerMenuState state = Provider.of(context);

    return Material(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: drawerDecoration ?? BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(height: 10),
                  ),
                  SizedBox(
                        height: HiddenDrawer.of(context).drawerHeaderHeight,
                        width: HiddenDrawer.of(context).drawerWidth,
                        child: Align(alignment: Alignment.bottomLeft, child: header != null ? header : Container()),
                      )
                    ] +
                    menu.map((item) {
                      int index = menu.indexOf(item);
                      return InkWell(
                        onTap: () {
                          state.changeIndexState(index);
                          HiddenDrawer.of(context).handleDrawer();
                          item.onPressed();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          color: state.currentMenuIndex == index ? menuActiveColor : menuColor,
                          child: item.child,
                        ),
                      );
                    }).toList() +
                    [
                      SizedBox(
                        height: size.height * .1,
                        width: HiddenDrawer.of(context).drawerWidth,
                        child: footer != null ? footer : Container(),
                      ),
                      Expanded(
                        child: SizedBox(height: 10),
                      ),
                    ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
