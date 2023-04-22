import 'dart:async';
import 'dart:convert';

import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:flutter/material.dart';

import './userActiveSessions/screen.dart';
import './userProfileData/screen.dart';
import './userSettings/screen.dart';

class UserProfile extends StatefulWidget {
  final Map<String, String> env_values;
  const UserProfile({Key? key, this.env_values = const {}}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map profileData = {};
  Map pendingRequests = {};
  int currentTab = 0;
  late Timer timerIntervalToCheckLoginStatus;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void checkExistingSession() {
    // if (pendingRequests["login_status"] != null) {
    //   try {
    //     pendingRequests["login_status"].abort();
    //   } catch (e) {}
    // }
    exeFetch(
      uri: "/api/login_status/",
      getRequest: (req) => pendingRequests["login_status"] = req,
    )
        .then((value) => pendingRequests["login_status"] = null)
        .catchError((e) => Navigator.pushReplacementNamed(context, "/"));
  }

  Future getUserData() {
    Completer c = Completer();
    exeFetch(
        uri: "/api/user/",
        navigateToIfNotAllowed: (statusCode) =>
            Navigator.pushReplacementNamed(context, "/")).then((data) {
      setState(() {
        profileData = jsonDecode(data["body"])["data"];
      });
      c.complete(jsonDecode(data["body"])["data"]);
    }).catchError((e) => c.completeError(e));
    return c.future;
  }

  void logout() async {
    exeFetch(
      uri: "/api/user/logout/",
    ).then((value) async {
      temp_store["cookies"] = null;
      await storage.delete(key: "cookies");
      Navigator.pushReplacementNamed(context, "/");
    }).catchError((e) => print(e));
  }

  @override
  void initState() {
    super.initState();
    checkExistingSession();
    timerIntervalToCheckLoginStatus =
        Timer.periodic(const Duration(seconds: 10), (timer) {
      if (pendingRequests["login_status"] == null) {
        checkExistingSession();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timerIntervalToCheckLoginStatus.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Email:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        profileData["email"] ?? "loading...",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const Text("UUID:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Text(
                          profileData["uuid"] ?? "loading...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  setState(() {
                    currentTab = 0;
                  });
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      color: currentTab == 0 ? Colors.blue[800] : Colors.black,
                    ),
                  ),
                )),
            TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  setState(() {
                    currentTab = 1;
                  });
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: Text(
                    "Active sessions",
                    style: TextStyle(
                      color: currentTab == 1 ? Colors.blue[800] : Colors.black,
                    ),
                  ),
                )),
            TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  setState(() {
                    currentTab = 2;
                  });
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      color: currentTab == 2 ? Colors.blue[800] : Colors.black,
                    ),
                  ),
                )),
            TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: logout,
                child: const ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("User profile"),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                ),
                onPressed: logout,
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 10.0),
                    Text("Logout"),
                  ],
                ))
          ],
        ),
        // automaticallyImplyLeading: false,
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: (() {
            switch (currentTab) {
              case 0:
                return UserProfileData(getUserData: getUserData);
              case 1:
                return const UserActiveSessions();
              case 2:
                return const UserSettings();
              default:
                return const Text("Todo");
            }
          })()),
    );
  }
}
