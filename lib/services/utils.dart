import 'dart:async';

class CustomEvent {
  late StreamController controller;
  Timer? _timer;
  CustomEvent() {
    controller = StreamController.broadcast();
  }
  void sendEvent(data) => controller.add(data);
  Stream get getStream => controller.stream;
  set timer(Timer t) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = t;
  }
}

class Debounce {
  Duration delay;
  Timer? _timer;
  Debounce({this.delay = const Duration(milliseconds: 200)});

  set callback(Function() cb) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(delay, cb);
  }
}
