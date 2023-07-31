import 'dart:math';

import 'package:flutter/material.dart';

class ShakingDialog extends StatefulWidget {
  final Widget child;
  final ShapeBorder shape;
  const ShakingDialog({
    Key? key, required this.child, required this.shape,
  }) : super(key: key);

  @override
  ShakingDialogState createState() {
    return ShakingDialogState();
  }
}

class ShakingDialogState extends State<ShakingDialog>
    with SingleTickerProviderStateMixin{
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 250), vsync: this,);
  final double _shakeDistance = 10;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final dx = sin(_controller.value * 2 * pi) * _shakeDistance;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: Dialog(
        shape: widget.shape,
        child: widget.child,
      ),
    );
  }

  void shake() {
    _controller.forward(from: 0.0);
  }
}