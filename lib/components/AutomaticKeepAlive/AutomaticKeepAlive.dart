import 'package:flutter/material.dart';

class MyAutomaticKeepAlive extends StatefulWidget {
  final Widget child;

  const MyAutomaticKeepAlive({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MyAutomaticKeepAlive> createState() => _AutomaticKeepAliveState();
}

class _AutomaticKeepAliveState extends State<MyAutomaticKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
