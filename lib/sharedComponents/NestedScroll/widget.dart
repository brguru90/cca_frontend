import 'package:flutter/material.dart';

class CustomNestedScroll {
  Map<int, ScrollController> scrollControllers = {};
  List<int> scrollViewIdentifiers = [];

  double totalScrolledOffset = 0;

  _onStartScroll(ScrollMetrics metrics) {
    // print("Scroll Start,${metrics.pixels}");
    totalScrolledOffset = metrics.pixels;
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    // print("Scroll Update,${metrics.pixels}");
    // print(metrics);
  }

  _onEndScroll(ScrollMetrics metrics, int currentControllerIndex) {
    if (currentControllerIndex == 0) return;

    totalScrolledOffset = (totalScrolledOffset - metrics.pixels).abs();
    if (totalScrolledOffset != 0) {
      // skipping parent scroll if its just reached to beginning/end first time
      return;
    }

    final parentScrollViewIdentifier =
        scrollViewIdentifiers[currentControllerIndex - 1];
    // print("Scroll End,${metrics.pixels} current scrollView=${parentScrollViewIdentifier}");

    final parentScrollController =
        scrollControllers[parentScrollViewIdentifier];
    final double parentScrollViewCurrentOffset = parentScrollController!.offset;

    // print(parentScrollViewCurrentOffset);

    if (metrics.pixels == metrics.maxScrollExtent) {
      // scroll to end
      parentScrollController.animateTo(
        parentScrollViewCurrentOffset + 100,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    } else if (metrics.pixels == metrics.minScrollExtent) {
      // scroll to beginning
      parentScrollController.animateTo(
        parentScrollViewCurrentOffset - 100,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }
  }

  Widget getScrollView(
      int viewIdentifier, Widget Function(ScrollController?) callback) {
    late ScrollController? scrollController;
    if (scrollControllers[viewIdentifier] == null) {
      scrollController = ScrollController();
      scrollControllers[viewIdentifier] = scrollController;
      scrollViewIdentifiers.add(viewIdentifier);
    } else {
      scrollController = scrollControllers[viewIdentifier];
    }
    final int currentControllerIndex = scrollViewIdentifiers.length - 1;
    return NotificationListener(
      child: callback(scrollController),
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          _onStartScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollUpdateNotification) {
          _onUpdateScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollEndNotification) {
          _onEndScroll(scrollNotification.metrics, currentControllerIndex);
        }
        return true;
      },
    );
  }
}
