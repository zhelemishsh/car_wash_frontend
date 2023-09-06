import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  final Widget child;
  final Widget title;

  const DropdownList({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  DropdownListState createState() {
    return DropdownListState();
  }
}

class DropdownListState extends State<DropdownList>
    with TickerProviderStateMixin {
  bool _isOpened = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    return DataPanel(
      backgroundColor: AppColors.grey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: widget.title),
              _openButton(),
            ],
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              children: [
                const Divider(color: AppColors.lightOrange,),
                widget.child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _openButton() {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: () {
          if (_isOpened) {
            _controller.reverse();
          }
          else {
            _controller.forward();
          }
          _isOpened = !_isOpened;
          setState(() {});
        },
        padding: EdgeInsets.zero,
        highlightColor: AppColors.orange.withOpacity(0.1),
        constraints: const BoxConstraints(),
        icon: Icon(
          _isOpened ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
          color: AppColors.lightOrange,
          size: 40,
        ),
      ),
    );
  }
}
