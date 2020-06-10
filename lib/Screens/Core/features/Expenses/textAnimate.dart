import 'package:flutter/material.dart';

class TextAnimate<T> extends StatefulWidget {
  final T initialData;
  final T data;
  final Duration duration;
  final Widget Function(T data) builder;
  final VoidCallback onFadeComplete;

  const TextAnimate({
    @required this.initialData,
    @required this.data,
    @required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.onFadeComplete,
  });

  @override
  _TextAnimateState<T> createState() => _TextAnimateState<T>();
}

class _TextAnimateState<T> extends State<TextAnimate<T>>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  T dataToShow;

  @override
  void initState() {
    super.initState();
    dataToShow = widget.initialData;
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          dataToShow = widget.data;
          controller.reverse(from: 1.0);
        } else if (status == AnimationStatus.dismissed) {
          widget?.onFadeComplete?.call();
        }
      });

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
    if (widget.initialData != widget.data) {
      controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextAnimate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      dataToShow = oldWidget.data;
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 1.0 - animation.value,
        child: widget.builder(dataToShow),
      );
}
