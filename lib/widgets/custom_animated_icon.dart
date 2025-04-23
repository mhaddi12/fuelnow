import 'package:flutter/material.dart';
import 'dart:async'; // For periodic animation

class AutoAnimatedIcon extends StatefulWidget {
  final IconData firstIcon;
  final IconData secondIcon;
  final double size;
  final Color color;
  final Duration duration;
  final Duration interval;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  const AutoAnimatedIcon({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    this.size = 60,
    this.color = Colors.blue,
    this.duration = const Duration(milliseconds: 300),
    this.interval = const Duration(seconds: 1), // Interval for auto toggling
    this.transitionBuilder,
  });

  @override
  State<AutoAnimatedIcon> createState() => _AutoAnimatedIconState();
}

class _AutoAnimatedIconState extends State<AutoAnimatedIcon> {
  bool _isToggled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Periodic animation toggle
    _timer = Timer.periodic(widget.interval, (_) {
      setState(() {
        _isToggled = !_isToggled;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: widget.transitionBuilder ??
              (child, animation) => RotationTransition(
            turns: animation,
            child: child,
          ),
      child: Icon(
        _isToggled ? widget.secondIcon : widget.firstIcon,
        key: ValueKey(_isToggled),
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}
