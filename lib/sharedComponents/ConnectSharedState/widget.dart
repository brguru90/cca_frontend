import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:flutter/material.dart';

class ConnectSharedState extends StatefulWidget {
  final SharedState sharedStateObj;
  final Widget Function() updateWidget;
  const ConnectSharedState(
      {Key? key, required this.updateWidget, required this.sharedStateObj})
      : super(key: key);

  @override
  State<ConnectSharedState> createState() => _ConnectSharedStateState();
}

class _ConnectSharedStateState extends State<ConnectSharedState> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.sharedStateObj
          .connectSetState(setState: setState, isMounted: () => mounted);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.updateWidget();
  }
}
