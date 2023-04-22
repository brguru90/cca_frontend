import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final String? redirectRoute;
  final int delay;
  final Function? getController;

  const CustomLoader({
    Key? key,
    this.width = 150,
    this.height = 150,
    this.delay = 2000,
    this.redirectRoute,
    this.getController,
  }) : super(key: key);

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with TickerProviderStateMixin {
  bool componentDisposed = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();

    if (widget.getController != null) {
      widget.getController!(_controller);
    }

    if (widget.redirectRoute != null) {
      componentDisposed = false;
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (componentDisposed == false) {
          Navigator.pushNamedAndRemoveUntil(context, widget.redirectRoute ?? "",
              (Route<dynamic> route) => false);
        }
      });
    }
  }

  @override
  void dispose() {
    componentDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
      child: AnimateRotation(
        controller: _controller,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

class AnimateRotation extends AnimatedWidget {
  final double? width, height;
  const AnimateRotation({
    Key? key,
    required AnimationController controller,
    this.width,
    this.height,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _progress.value * 2.0 * pi,
      child: SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset('assets/icons/loader.svg'),
      ),
    );
  }
}
