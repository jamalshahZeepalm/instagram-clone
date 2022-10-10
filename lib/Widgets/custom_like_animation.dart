
// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget myChild;
  final bool isAnimating;
  final VoidCallback? onEnd;
  final Duration? duration;
  final bool? smalLike;
  const LikeAnimation({
    super.key,
    required this.myChild,
    required this.isAnimating,
      this.smalLike=false,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration!.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // ignore: todo
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget) {
      startAnimating();
    }
  }

  startAnimating() async {
    if (widget.isAnimating || widget.smalLike!) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.myChild,
    );
  }
}
