import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: AppColors.orange,
      ),
    ),
    title: 'Navigation Basics',
    // home: CarWashSelectionPage(),
    home: MainPage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin{
  int num = 1;
  bool _isHidden = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  if (_isHidden) {
                    Future(_openBottomPanel).then((_) => print("opened!"));
                  }
                  else {
                    Future(_closeBottomPanel).then((_) => print("closed!"));
                  }
                },
                child: Text("kal"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _kekWidget(),
          )
        ],
      ),
    );
  }

  void _openBottomPanel() async {
    if (!_isHidden) return;
    await _controller.reverse();
    _isHidden = false;
  }

  void _closeBottomPanel() async {
    if (_isHidden) return;
    await _controller.forward();
    _isHidden = true;
  }

  Widget _kekWidget() {
    return SlideTransition(
      position: Tween(
        begin: Offset.zero,
        end: const Offset(0, 2),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      )),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        color: Colors.white,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(num.toString()), Text(num.toString()), Text(num.toString()),
            ],
          ),
        )
      )
    );
  }
}

