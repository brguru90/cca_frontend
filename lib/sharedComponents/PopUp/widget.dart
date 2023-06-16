import 'dart:async';
import 'dart:ui';

import 'package:cca_vijayapura/sharedComponents/NestedWillPopScope/widget.dart';
import 'package:flutter/material.dart';

class CustomPopupOptions {
  final bool filled;
  final Key? overlayContainerKey;
  final double dx, dy;
  double? left, right, top, bottom, width, height;
  final Function(Function())? setState;

  CustomPopupOptions({
    required this.filled,
    this.overlayContainerKey,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.width,
    this.height,
    this.dx = 0,
    this.dy = 0,
    this.setState,
  });
}

class CustomPopup {
  final Widget Function({
    required bool alignLeft,
    required bool alignRight,
    required bool alignTop,
    required bool alignBottom,
  }) provideOverlayWidget;
  Color? overlayBackgroundColor;
  OverlayEntry? overlayEntry;
  OverlayState? overlayState;
  bool bgBlur;

  CustomPopup(
      {required this.provideOverlayWidget,
      overlayBackgroundColor,
      this.bgBlur = false}) {
    this.overlayBackgroundColor =
        overlayBackgroundColor ?? Colors.white.withOpacity(0.2);
  }

  Widget NestWithCustomPopup({required Widget child}) {
    return NestedWillPopScope(
      child: child,
      onWillPop: (data) async {
        if (overlayEntry == null) {
          return Future.value(true);
        }
        hide();
        return Future.value(false);
      },
    );
  }

  void _showOverlayFromBottom({
    required BuildContext parentContext,
    CustomPopupOptions? customPopupOptions,
  }) async {
    Widget getPositioned({
      required BuildContext currentContext,
      required BuildContext overlayContext,
      filled = false,
      required double height,
      required double width,
      required Widget Function({
        required bool alignLeft,
        required bool alignRight,
        required bool alignTop,
        required bool alignBottom,
      })
          provideOverlayWidget2,
    }) {
      if (customPopupOptions == null || customPopupOptions.filled) {
        return provideOverlayWidget2(
          alignBottom: false,
          alignLeft: false,
          alignRight: false,
          alignTop: false,
        );
      } else {
        final RenderBox? renderBox =
            currentContext.findRenderObject() as RenderBox?;
        Offset local = renderBox?.globalToLocal(
                Offset(customPopupOptions.dx, customPopupOptions.dy)) ??
            Offset.zero;

        final fixedPos = CustomPopupOptions(
          filled: false,
        );

        if (customPopupOptions.setState != null) {
          Timer(const Duration(seconds: 1), () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              customPopupOptions.setState!(() {});
              print("hi");
            });
          });
        }

        double maxHeight = height;
        double maxWidth = width;
        EdgeInsets statusBarPadding = MediaQuery.of(overlayContext).viewPadding;
        double systemScreenGap = statusBarPadding.top + statusBarPadding.bottom;
        // kToolbarHeight

        if ((width / 2) < (customPopupOptions.dx)) {
          fixedPos.right = width - (customPopupOptions.dx);
          maxWidth = (customPopupOptions.dx);
        } else {
          fixedPos.left = (customPopupOptions.dx);
          maxWidth = width - (customPopupOptions.dx);
        }

        if ((height / 2) < (customPopupOptions.dy)) {
          fixedPos.bottom = height - (customPopupOptions.dy);
          maxHeight = (customPopupOptions.dy) - systemScreenGap;
        } else {
          fixedPos.top = (customPopupOptions.dy) - systemScreenGap;
          maxHeight = height - (customPopupOptions.dy);
        }

        //

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height,
            maxWidth: width,
          ),
          // color: Colors.blue,
          child: Stack(
            children: [
              Positioned(
                left: fixedPos.left,
                top: fixedPos.top,
                bottom: fixedPos.bottom,
                right: fixedPos.right,
                child: Container(
                  // color: Colors.blue,
                  constraints: BoxConstraints(
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  // color: Colors.blue,
                  child: provideOverlayWidget2(
                    alignBottom: fixedPos.bottom != null,
                    alignLeft: fixedPos.left != null,
                    alignRight: fixedPos.right != null,
                    alignTop: fixedPos.top != null,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    Widget withBlur({required Widget child}) {
      if (bgBlur) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: child,
        );
      }
      return child;
    }

    overlayState = Overlay.of(parentContext);
    overlayEntry = OverlayEntry(builder: (context) {
      return Scaffold(
        // extendBodyBehindAppBar: customPopupOptions?.filled != true,
        backgroundColor: overlayBackgroundColor,
        body: SafeArea(
          // top: customPopupOptions?.filled == true,
          child:
              LayoutBuilder(builder: (safeContext, BoxConstraints constraints) {
            final height = MediaQuery.of(safeContext).size.height;
            final width = MediaQuery.of(safeContext).size.width;
            print(height);
            return Stack(
              children: [
                Positioned.fill(
                  child: withBlur(
                    child: GestureDetector(
                      onTap: hide,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Positioned.fill(
                      left: 0,
                      top: 0,
                      child: getPositioned(
                        height: height,
                        width: width,
                        filled: customPopupOptions?.filled == true,
                        currentContext: safeContext,
                        overlayContext: context,
                        provideOverlayWidget2: (
                                {required bool alignBottom,
                                required bool alignLeft,
                                required bool alignRight,
                                required bool alignTop}) =>
                            Padding(
                          key: customPopupOptions?.overlayContainerKey,
                          padding: customPopupOptions == null ||
                                  customPopupOptions.filled == true
                              ? const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 20,
                                )
                              : EdgeInsets.zero,
                          child: Container(
                            decoration: const BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black,
                              //     blurRadius: 10.0,
                              //     spreadRadius: 2,
                              //     offset: Offset(
                              //       0.0,
                              //       0.0,
                              //     ),
                              //   )
                              // ],
                              color: Colors.transparent,
                              // borderRadius: BorderRadius.all(
                              //   Radius.circular(
                              //     10.0,
                              //   ),
                              // ),
                            ),
                            child: customPopupOptions == null ||
                                    customPopupOptions.filled == true
                                ? ClipRRect(
                                    child: provideOverlayWidget(
                                        alignBottom: alignBottom,
                                        alignLeft: alignLeft,
                                        alignRight: alignRight,
                                        alignTop: alignTop),
                                    //  borderRadius: BorderRadius.all(
                                    //     Radius.circular(
                                    //       10.0,
                                    //     ),
                                    //   ),
                                  )
                                : provideOverlayWidget(
                                    alignBottom: alignBottom,
                                    alignLeft: alignLeft,
                                    alignRight: alignRight,
                                    alignTop: alignTop),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      );
    });

    overlayState?.insert(overlayEntry!);
  }

  void show(context) {
    if (overlayEntry != null) return;
    _showOverlayFromBottom(parentContext: context, customPopupOptions: null);
    // startAnimation();
  }

  Widget showBellow(
      {required Widget child, required Function(Function()) setStateCallBack}) {
    Key overlayContainerKey = GlobalKey();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        child: child,
        onTapDown: (TapDownDetails details) {
          _showOverlayFromBottom(
            parentContext: context,
            customPopupOptions: CustomPopupOptions(
              filled: false,
              overlayContainerKey: overlayContainerKey,
              // ! Need to fix, Positions not working properly in nested Navigators
              dx: details.globalPosition.dx,
              dy: details.globalPosition.dy,
            ),
          );
        },
      );
    });
  }

  Widget showBellowWithContext(
      {required Widget child,
      required BuildContext context,
      required Function(Function()) setStateCallBack}) {
    Key overlayContainerKey = GlobalKey();

    return GestureDetector(
      child: child,
      onTapDown: (TapDownDetails details) {
        _showOverlayFromBottom(
          parentContext: context,
          customPopupOptions: CustomPopupOptions(
            filled: false,
            overlayContainerKey: overlayContainerKey,
            dx: details.globalPosition.dx,
            dy: details.globalPosition.dy,
          ),
        );
      },
    );
  }

  void hide() {
    // animationController!.reverse(from: 1).then((value) {
    overlayEntry?.remove();
    overlayEntry = null;
    // });
  }
}
