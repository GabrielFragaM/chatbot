import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final double? paddingLeft;
  final double? paddingRight;
  final List<Widget> children;

  const CustomListView(
      {Key? key,
        required this.children,
        this.paddingRight,
        this.paddingLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.only(
              left: paddingLeft ?? 0,
              right: paddingRight ?? 0
          ),
          children: children,
        ),
      ),
    );
  }
}