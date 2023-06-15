import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:cca_vijayapura/sharedState/types/stacked_overlay.dart';
import 'package:flutter/material.dart';

mixin OverlayStackMixin {
  int getHighestTopIndexFromOverlayStack() =>
      overlayStack.state.overlays.isNotEmpty
          ? overlayStack.state.overlays.last.topIndex
          : -1;

  void addToOverlayStack({required Widget widget, String? id}) {
    final tempStack = overlayStack.state;
    final toTopIndex = getHighestTopIndexFromOverlayStack() + 1;
    tempStack.overlays.add(StackedOverlayType(
      widget: widget,
      topIndex: toTopIndex,
      id: id ?? toTopIndex.toString(),
    ));
    tempStack.overlays.sort((a, b) => a.topIndex.compareTo(b.topIndex));
    overlayStack.state = tempStack;
  }

  int removeFromOverlayStack() {
    final tempStack = overlayStack.state;
    if (tempStack.overlays.isEmpty) return -1;
    tempStack.overlays.removeLast();
    overlayStack.state = tempStack;
    return tempStack.overlays.last.topIndex;
  }

  int removeByIDFromOverlayStack(String id) {
    final tempStack = overlayStack.state;
    if (tempStack.overlays.isEmpty) return -1;
    tempStack.overlays.removeWhere((element) => element.id == id);
    overlayStack.state = tempStack;
    if (tempStack.overlays.isEmpty) return -1;
    return tempStack.overlays.last.topIndex;
  }
}
