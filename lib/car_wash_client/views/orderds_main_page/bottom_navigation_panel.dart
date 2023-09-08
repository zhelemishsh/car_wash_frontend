import 'package:flutter/material.dart';

import 'page_navigatrion_button.dart';

class BottomNavigationPanel extends StatefulWidget {
  final PageController navigationPageController;
  final List<NavigationButtonData> navigationButtonsData;

  const BottomNavigationPanel({
    Key? key,
    required this.navigationPageController,
    required this.navigationButtonsData,
  }) : super(key: key);

  @override
  BottomNavigationPanelState createState() {
    return BottomNavigationPanelState();
  }
}

class BottomNavigationPanelState extends State<BottomNavigationPanel> {
  late int currentPage;
  List<NavigationButtonKeyData> _keyData = [];

  @override
  void initState() {
    for (int i = 0; i < widget.navigationButtonsData.length; ++i) {
      _keyData.add(NavigationButtonKeyData(
        widget.navigationButtonsData[i], GlobalKey<PageNavigationButtonState>(), i,
      ));
    }

    widget.navigationPageController.addListener(() {
      if (currentPage != widget.navigationPageController.page!.round()) {
        _keyData[currentPage].key.currentState!.close().then((_) {
          currentPage = widget.navigationPageController.page!.round();
          _keyData[currentPage].key.currentState!.open();
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentPage = widget.navigationPageController.page!.round();
      _keyData[currentPage].key.currentState!.open();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _keyData.map((keyData) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PageNavigationButton(
            key: keyData.key,
            iconData: keyData.data.iconData,
            text: keyData.data.text,
            onPressed: () {
              if (currentPage != keyData.page) {
                widget.navigationPageController.jumpToPage(keyData.page);
              }
              setState(() {});
            },
          ),
        );
      }).toList(),
    );
  }
}

class NavigationButtonData {
  IconData iconData;
  String text;

  NavigationButtonData(this.iconData, this.text);
}

class NavigationButtonKeyData {
  NavigationButtonData data;
  GlobalKey<PageNavigationButtonState> key;
  int page;

  NavigationButtonKeyData(this.data, this.key, this.page);
}