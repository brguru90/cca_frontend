import 'package:cca_vijayapura/sharedComponents/ConnectSharedState/widget.dart';
import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:flutter/material.dart';

class CustomOverLayStack extends StatelessWidget {
  final Widget child;
  const CustomOverLayStack({Key? key, required this.child}) : super(key: key);
// overlayStack
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        ConnectSharedState(
          sharedStateObj: unOrganizedState,
          // updateWidget: () => Transform.translate(
          //   offset: Offset(
          //     (unOrganizedState.state?["mainTranslateX"] ?? 0) + 0.0,
          //     (unOrganizedState.state?["mainTranslateY"] ?? 0) + 0.0,
          //   ),
          //   child: child,
          // ),
          updateWidget: () => AnimatedPositioned(
            top: (unOrganizedState.state?["mainTranslateY"] ?? 0) + 0.0,
            left: (unOrganizedState.state?["mainTranslateX"] ?? 0) + 0.0,
            width: width,
            height: height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
            child: child,
          ),
        ),
        ConnectSharedState(
          sharedStateObj: overlayStack,
          updateWidget: () => Positioned.fill(
            child: Stack(
              children:
                  overlayStack.state.overlays.map((e) => e.widget).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
