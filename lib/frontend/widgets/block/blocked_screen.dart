import 'package:flutter/material.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  _BlockedScreenState createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {


  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: ModalBarrier(
        dismissible: false,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}
