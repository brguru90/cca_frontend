import 'dart:convert';
import 'dart:math';

import 'package:cca_vijayapura/screens/StudyMaterials/docSlider/widget.dart';
import 'package:cca_vijayapura/screens/StudyMaterials/filter_docs.dart';
import 'package:cca_vijayapura/screens/StudyMaterials/purchaseBar/widget.dart';
import 'package:cca_vijayapura/screens/home/bottomNavBar.dart';
import 'package:cca_vijayapura/screens/home/header.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:flutter/material.dart';

class StudyMaterials extends StatefulWidget {
  const StudyMaterials({Key? key}) : super(key: key);

  @override
  State<StudyMaterials> createState() => _StudyMaterialsState();
}

class _StudyMaterialsState extends State<StudyMaterials> {
  ScrollController scrollController = ScrollController();
  double scrollCount = 0;
  List<DocumentLists> docList = [];
  List<String> categories = [];
  String selectedCategories = "", selectedSort = "Title", currentTitle = "";
  Map<String, String?> docsSubscription = {};
  double currentPage = 1, maxPage = 1;

  void sortDocLis(value) {
    setState(() {
      selectedSort = value;
    });
    if (selectedSort == "Title") {
      setState(() {
        docList.sort((a, b) => a.title.compareTo(b.title));
      });
    } else if (selectedSort == "Date") {
      docList.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
    }
  }

  void fetchStudyMaterialList() {
    // ?search_title=dsgvd&search_category=fgnfh&page=1
    String uri = "/api/user/study_materials/?page=${currentPage.round()}";
    if (currentTitle != "") {
      uri += "&search_title=$currentTitle";
    }
    if (selectedCategories != "" && selectedCategories != "None") {
      uri += "&search_category=$selectedCategories";
    }

    exeFetch(uri: uri).then((body) {
      final data = jsonDecode(body["body"])["data"];
      shared_logger.d(data);
      setState(() {
        maxPage = data["count"] / data["page_size"];
        docList = (data["list"] as List).map((doc) {
          return DocumentLists(
              id: doc["_id"],
              title: doc["title"],
              description: doc["description"],
              createdBy: doc["created_by_user"],
              category: doc["category"],
              linkToBookCoverImage: doc["link_to_book_cover_image"],
              linkToDocument: doc["link_to_doc_file"],
              price: doc["price"],
              blockSize: doc["file_decryption_key_blk_size"],
              lastUpdated: DateTime.parse(doc["updatedAt"]));
        }).toList();
        sortDocLis("Title");
      });
      shared_logger.d(docList);
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  void fetchStudyMaterialCategories() {
    exeFetch(uri: "/api/user/study_materials_categories/").then((body) {
      final data = jsonDecode(body["body"])["data"] as List;
      shared_logger.d(data);
      setState(() {
        categories = data.map((cat) {
          return cat["title"] as String;
        }).toList();
      });
      shared_logger.d(docList);
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  void fetchSubscriptions() {
    exeFetch(
      uri: "/api/user/get_user_study_material_subscriptions/",
    ).then((body) {
      final data = jsonDecode(body["body"])["data"] as List;
      shared_logger.d(data);
      setState(() {
        setState(() {
          for (var subscription in data) {
            docsSubscription[subscription["study_material_id"]] =
                subscription["expired_on"];
          }
        });
      });
      shared_logger.d(docsSubscription);
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  onCategoryChange(val) {
    setState(() {
      selectedCategories = val;
    });
    fetchStudyMaterialList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStudyMaterialList();
      fetchSubscriptions();
      fetchStudyMaterialCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedForPurchase =
        docList.where((doc) => doc.selectedForPurchase).toList();

    return Scaffold(
      // appBar: AppBar(
      //   title: const HomeHeader(),
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: HomeHeader(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/training.png",
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                  const Text(
                    "Study Materials",
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Color(0xFF6750A3),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0, // shadow blur
                          color: Color.fromARGB(
                              255, 145, 142, 142), // shadow color
                          offset:
                              Offset(2.0, 3.0), // how much shadow will be shown
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              FilterDocs(
                categoryList: categories,
                selectedCategory: selectedCategories,
                onCategoryChange: onCategoryChange,
                selectedSort: selectedSort,
                currentPage: currentPage,
                maxPage: maxPage,
                onSortChange: sortDocLis,
                onTitleChange: (title) {
                  setState(() {
                    currentTitle = title;
                  });

                  fetchStudyMaterialList();
                },
                onPageChange: (isForward) {
                  if (isForward) {
                    setState(() {
                      currentPage = min(currentPage + 1, maxPage);
                    });
                  } else {
                    setState(() {
                      currentPage = max(currentPage - 1, 1);
                    });
                  }
                  fetchStudyMaterialList();
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.metrics.axis ==
                                  Axis.vertical) {
                            setState(() {
                              scrollCount = scrollNotification.metrics.pixels;
                            });
                          }
                          return true;
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DocSlider(
                              docList: docList,
                              subscription: docsSubscription,
                              onPurchaseClick: (index) {
                                setState(() {
                                  docList[index].selectedForPurchase =
                                      !docList[index].selectedForPurchase;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    scrollCount >= 2
                        ? Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: 50,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.0,
                                    0.5,
                                    1,
                                  ],
                                  colors: [
                                    Color.fromARGB(255, 255, 255, 255),
                                    Color.fromARGB(135, 255, 255, 255),
                                    Color.fromARGB(0, 255, 255, 255),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Positioned(
                            height: 0,
                            width: 0,
                            child: SizedBox(),
                          ),
                  ],
                ),
              ),
              StudyMaterialPurchaseSummaryView(
                selectedStudymaterials: selectedForPurchase,
                reloadSubscriptionStatus: () {
                  fetchSubscriptions();
                  fetchStudyMaterialList();
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
