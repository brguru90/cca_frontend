import 'dart:async';
import 'dart:convert';

import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';

Map temp_store = {};
Map<String, CustomEvent> sharedEvents = {};
final shared_logger = Logger();

void temp_store_reset() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  temp_store = {"deviceInfo": map};
}

class SharedState<T> {
  String? _key;
  CustomEvent? _customEvent;
  CustomEvent? _afterUpdate;
  StreamSubscription? _eventSubscription;
  final Function _emptyCallBack = () {};
  final List<Function> _callbacks = [];
  bool _persist = false;
  final T Function(Map)? _parseToType;
  final Map Function(T)? _parseToTMap;

  SharedState({
    String? key,
    initialState,
    persist = false,
    T Function(Map)? parseToType,
    Map Function(T)? parseToTMap,
  })  : _parseToType = parseToType,
        _parseToTMap = parseToTMap {
    if (key == "all_the_state") {
      throw "key not allowed";
    }

    if (key != null) {
      key = "shared_state__$key";
    }

    _key = key;
    _persist = persist;
    // set the event if its not present or else get existing event
    if (key != null) {
      sharedEvents[key] ??= CustomEvent();
      _customEvent = sharedEvents[key];
    } else {
      sharedEvents["all_the_state"] ??= CustomEvent();
      _customEvent = sharedEvents["all_the_state"];
    }

    if (persist && initialState == null) {
      storage.read(key: key).then((value) => state = value);
    }
    if (temp_store[key] == null) {
      _updateStoreData(initialState, key, persist);
    }
    _afterUpdate = CustomEvent();
    _bindUpdateCallback();
  }

  void _updatePersistStore(key, persist) {
    if (T is! dynamic) {
      try {
        if (persist) {
          if (_parseToTMap != null) {
            storage.write(key: key, value: _parseToTMap!(temp_store[key]));
          } else {
            storage.write(key: key, value: temp_store[key]);
          }
        }
      } catch (e) {
        shared_logger.e(
            "error while calling parseToType:\n" + jsonEncode(temp_store[key]));
        rethrow;
      }
    } else {
      shared_logger.wtf(
          "Only work if specified type is user defined class type or Map:\n" +
              T.toString());
    }
  }

  void _updateStoreData(newState, key, persist) {
    if (newState is T) {
      try {
        temp_store[key] = newState;
        if (persist) {
          if (_parseToTMap != null) {
            storage.write(key: key, value: _parseToTMap!(newState));
          } else {
            storage.write(key: key, value: newState);
          }
        }
      } catch (e) {
        shared_logger
            .e("error while calling parseToType:\n" + jsonEncode(newState));
        rethrow;
      }
    } else if (newState is Map) {
      if (newState.isNotEmpty) {
        if (_parseToType != null) {
          temp_store[key] = _parseToType!(newState);
        } else {
          temp_store[key] = newState;
        }
        if (persist) {
          storage.write(key: key, value: newState);
        }
      } else {
        if (null is! T) {
          throw Exception(
              "Value for specified($T) type can't be null, got type ${newState.runtimeType}\nwith value $newState");
        }
        temp_store[key] = null;
        if (persist) {
          storage.delete(key: key);
        }
      }
    } else if (newState == null) {
      if (null is! T) {
        throw Exception(
            "Value for specified($T) type can't be null, got type ${newState.runtimeType}\nwith value $newState");
      }
      temp_store[key] = null;
      if (persist) {
        storage.delete(key: key);
      }
    } else {
      throw Exception(
          "Value should be of type Map or user defined Class, but got type ${newState.runtimeType}\nwith value $newState");
    }
  }

  void _cancelUpdateCallback() {
    if (_eventSubscription != null) _eventSubscription!.cancel();
  }

  void _bindUpdateCallback() {
    _cancelUpdateCallback();
    _eventSubscription = _customEvent!.controller.stream.listen((event) {
      Future.forEach(_callbacks, (Function cb) {
        cb(_emptyCallBack);
      }).then((value) {
        _afterUpdate!.sendEvent("");
      });
    });
  }

  dynamic _onAfterUpdate(value) {
    if (value is List && value.length == 2) {
      StreamSubscription? e;
      var cb = value[1] ?? () {};
      e = _afterUpdate!.controller.stream.listen((event) {
        cb();
        e?.cancel();
      });
      value = value[0];
    }
    return value;
  }

  /// Value should be of type Map or List of [Map,Function].
  ///
  /// where Map is the value to the state
  ///
  /// Function is the callback after all onStateUpdateCallback finishes, probably not needed in most of case
  set state(_value) {
    dynamic value = _onAfterUpdate(_value);
    _updateStoreData(value, _key, _persist);
    _customEvent!.sendEvent("");
  }

  /// update by reference
  updateState(Function(T state) callback) {
    callback(temp_store[_key]);
    _updatePersistStore(_key, _persist);
    _customEvent!.sendEvent("");
  }

  /// Value should be of type Map or List of [Map,Function].
  ///
  /// where Map is the value to the state
  ///
  /// Function is the callback after all onStateUpdateCallback finishes, probably not needed in most of case
  ///
  /// Note: only accept Map type
  ///
  /// !!! if you trying to update class or map on `large shared state`,
  /// use updateState instead of patchState, to directly update specific member of state
  set patchState(_value) {
    dynamic value = _onAfterUpdate(_value);
    if (value is! Map) {
      throw Exception(
          "patchState only accept Map type, but got type ${value.runtimeType}");
    }
    if (temp_store[_key] is Map) {
      _updateStoreData({...temp_store[_key], ...value}, _key, _persist);
    } else if (_parseToTMap != null) {
      _updateStoreData(
          {..._parseToTMap!(temp_store[_key]), ...value}, _key, _persist);
    }
    _customEvent!.sendEvent("");
  }

  /// read data from shared state.
  T get state {
    return temp_store[_key];
  }

  /// called when value of current sharedState changes
  ///
  /// !!! warning: Don't use to connect setState, use `connectSetState` instead
  set onStateUpdateCallback(Function callback) {
    _callbacks.add(callback);
  }

  /// rebuilds widget when value of current sharedState changes
  /// by connecting flutter setState & widget mount state
  /// Note:
  /// for optimization use bellow component to restrict re-render to specific scope/child widget tree
  /// lib/sharedComponents/ConnectSharedState/widget.dart
  connectSetState({
    required Function(Function()) setState,
    required bool Function() isMounted,
  }) {
    onStateUpdateCallback = (Function() setStateCallback) {
      if (isMounted()) {
        setState(setStateCallback);
      }
    };
  }
}
