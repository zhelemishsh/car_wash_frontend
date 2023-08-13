import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                spreadRadius: 2,
                blurRadius: 14,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: widget.child,
        ),
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