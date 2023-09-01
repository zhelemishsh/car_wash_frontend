import 'package:flutter/material.dart';

class BottomPanel extends StatefulWidget {
  final Widget child;

  const BottomPanel({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  BottomPanelState createState() {
    return BottomPanelState();
  }
}

class BottomPanelState extends State<BottomPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: Tween(
          begin: Offset.zero,
          end: const Offset(0, 2),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutQuad,
        )),
        child: widget.child,
      ),
    );
  }

  void openBottomPanel() async {
    if (!isHidden) return;
    isHidden = false;
    await _controller.reverse();
  }

  void closeBottomPanel() async {
    if (isHidden) return;
    isHidden = true;
    await _controller.forward();
  }
}