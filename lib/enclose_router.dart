import 'package:cca_vijayapura/sharedComponents/NestedWillPopScope/widget.dart';
import 'package:cca_vijayapura/sharedComponents/stackOverlay/widget.dart';
import 'package:flutter/material.dart';

class EncloseRoute extends StatelessWidget {
  final Widget child;
  const EncloseRoute({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup(data) async {
      if (ModalRoute.of(context)?.isFirst == false) {
        return true;
      }
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return NestedWillPopScope(
      onWillPop: showExitPopup,
      child: CustomOverLayStack(child: child),
    );
  }
}
