import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PageNavigationButton extends StatefulWidget {
  final double size;
  final Function() onPressed;
  final IconData iconData;
  final String text;

  const PageNavigationButton({
    Key? key,
    required this.iconData,
    required this.text,
    required this.onPressed,
    this.size = 45,
  }) : super(key: key);

  @override
  PageNavigationButtonState createState() {
    return PageNavigationButtonState();
  }
}

class PageNavigationButtonState extends State<PageNavigationButton>
    with TickerProviderStateMixin {
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
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(widget.size, widget.size),
        maximumSize: Size(double.infinity, widget.size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.size / 2),
        ),
        padding: const EdgeInsets.all(8),
        backgroundColor: AppColors.grey,
        foregroundColor: AppColors.orange,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.iconData,
            color: AppColors.orange,
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> open() async {
    await _controller.forward();
    setState(() {});
  }

  Future<void> close() async {
    await _controller.reverse();
    setState(() {});
  }
}