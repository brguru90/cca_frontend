import 'package:cca_vijayapura/screens/home/bottomNavBar.dart';
import 'package:cca_vijayapura/screens/home/header.dart';
import 'package:cca_vijayapura/services/auth.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/sharedComponents/orgBanner/widget.dart';
import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void logout(context) async {
    exeFetch(
      uri: "/api/user/logout/",
    ).then((value) async {
      try {
        await authSignOut();
      } catch (e) {
        ToastMessage.error(e.toString());
      }
      temp_store["cookies"] = null;
      await storage.delete(key: "cookies");
      Navigator.pushReplacementNamed(context, "/");
    }).catchError((e) => print(e));
  }

  Uri FullURI = Uri.parse(
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""");

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const HomeHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 243, 252, 255),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "About Us",
                                style: TextStyle(
                                    color: Color(0xFF6750A3),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const OrganizationBanner(
                                minWidth: 80,
                                minHeight: 0,
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Malghan building Meenakshi chowk Vijayapura, 586101",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 39, 39, 39),
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
                                    "Email: nimmachanakya.shree@gmail.com",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 39, 39, 39),
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _launchURL("$FullURI/#/privacy_policy"),
                                    child: const Text(
                                      "View privacy policy",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 39, 39, 39),
                                          fontSize: 18,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () => logout(context),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll<Color>(
                                      Color(0xFF6750A3)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                      color: Color.fromARGB(0, 255, 255, 255)),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 252, 255),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Developed by:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 28, 194),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Guruprasad BR",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 67, 255),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "brguru90@gmail.com",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 67, 255),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Mobile: 9482399078",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 67, 255),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Sathyanarayana",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 67, 255),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "sathyanitsme@gmail.com",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 67, 255),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Mobile: 8618059329",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 67, 255),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
