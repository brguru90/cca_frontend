import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/sharedState/types/user_type.dart';
import 'package:flutter/widgets.dart';

List<GlobalKey<NavigatorState>> navigationKeysState = [];

SharedState unOrganizedState =
    SharedState(key: "unorganized_state", initialState: {});

SharedState<UserType?> userData = SharedState<UserType?>(
  key: "user",
  initialState: {
    "username": "Buddy",
    "_id": "-1",
    "auth_provider": "fake",
  },
  parseToType: (state) => UserType.mapToClass(state),
  parseToTMap: (state) => state?.toMap() ?? {},
);
