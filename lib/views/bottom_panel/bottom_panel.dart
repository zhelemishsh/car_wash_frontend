import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BottomPanel extends StatefulWidget {
  final Widget Function() childBuilder;

  const BottomPanel({
    Key? key,
    required this.childBuilder,
  }) : super(key: key);

  @override
  BottomPanelState createState() {
    return BottomPanelState();
  }
}

class BottomPanelState extends State<BottomPanel> {
  final _childKey = GlobalKey<StatefulWrapperState>();
  bool _isPanelOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showBottomPanel(context);
      _isPanelOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: _isPanelOpened ? null : Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 60,
            height: 10,
            child: TextButton(
              onPressed: () {
                _isPanelOpened = true;
                _showBottomPanel(context);
                setState(() {});
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: AppColors.darkGrey,
              ),
              child: Container(),
            ),
          )
        )
      ],
    );
  }

  @override
  void setState(VoidCallback fn) {
    _childKey.currentState?.setState(() {});
    super.setState(fn);
  }

  Future<void> closePanel() async {
    if (_isPanelOpened) {
      _isPanelOpened = false;
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 300,));
      setState(() {});
    }
  }

  void _showBottomPanel(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return Container(
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
          padding: const EdgeInsets.all(6),
          child: StatefulWrapper(
            key: _childKey,
            childBuilder: widget.childBuilder,
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      enableDrag: false,
    );
  }
}

class StatefulWrapper extends StatefulWidget {
  final Widget Function() childBuilder;

  const StatefulWrapper({
    Key? key,
    required this.childBuilder
  }) : super(key: key);

  @override
  StatefulWrapperState createState() {
    return StatefulWrapperState();
  }
}

class StatefulWrapperState extends State<StatefulWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.childBuilder();
  }
}