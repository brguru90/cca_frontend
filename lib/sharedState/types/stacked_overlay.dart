import 'package:flutter/material.dart';

class StackedOverlayType {
  final Widget widget;
  final int topIndex;
  final String id;

  StackedOverlayType(
      {required this.widget, required this.topIndex, required this.id});
}

class StackedOverlay {
  final List<StackedOverlayType> overlays;

  const StackedOverlay({required this.overlays});

  static StackedOverlay mapToClass(Map mapObj) {
    return StackedOverlay(
      overlays: mapObj["overlays"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "overlays": overlays,
    };
  }
}
