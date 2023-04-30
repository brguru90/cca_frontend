import 'package:cca_vijayapura/screens/home/header.dart';
import 'package:cca_vijayapura/screens/home/latestUpdates.dart';
import 'package:cca_vijayapura/screens/home/services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const HomeHeader(),
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const HomeHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: const [
                    LatestUpdates(),
                    SizedBox(height: 10),
                    ProvidedServices(),
                    SizedBox(height: 10),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 20,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/icons/home.png", fit: BoxFit.cover),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child:
                    Image.asset("assets/icons/library.png", fit: BoxFit.cover),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/icons/ebook.png", fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
