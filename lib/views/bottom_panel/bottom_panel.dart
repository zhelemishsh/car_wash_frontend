import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class BottomPanel extends StatefulWidget {
  final double height;
  final Widget child;
  const BottomPanel({
    Key? key,
    required this.height,
    required this.child,
  }) : super(key: key);

  @override
  BottomPanelState createState() {
    return BottomPanelState();
  }
}

class BottomPanelState extends State<BottomPanel> {
  bool _isHidden = false;
  final double _swipePanelHeight = 20;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 0,
      right: 0,
      height: widget.height + _swipePanelHeight,
      bottom: _getBottomPosition(),
      curve: Curves.easeInQuad,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              spreadRadius: 2,
              blurRadius: 14,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            _isHidden
                ? _swipeDetectionPanel()
                : Container(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _swipeDetectionPanel() {
    return SwipeDetector(
      onSwipeDown: (offset) {
        hide();
      },
      onSwipeUp: (offset) {
        show();
      },
      child: Container(
        height: _swipePanelHeight,
        alignment: Alignment.center,
        child: Container(
          height: 8,
          width: 70,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: AppColors.lightGrey
          ),
        ),
      ),
    );
  }

  void hide() {
    _isHidden = true;
    setState(() {});
  }

  void show() {
    _isHidden = false;
    setState(() {});
  }

  double _getBottomPosition() {
    if (_isHidden) {
      return -widget.height;
    }
    else {
      return 0;
    }
  }
}