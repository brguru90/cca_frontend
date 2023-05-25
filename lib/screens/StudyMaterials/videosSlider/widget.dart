import 'dart:convert';

import 'package:cca_vijayapura/screens/coursePlaylist/widget.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:flutter/material.dart';

class DocumentLists {
  final String id, title, description, createdBy;
  final String linkToBookCoverImage, linkToDocument;
  final int price;
  final bool paid;

  DocumentLists({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.linkToBookCoverImage,
    required this.linkToDocument,
    required this.price,
    required this.paid,
  });
}

class DocSlider extends StatefulWidget {
  const DocSlider({Key? key}) : super(key: key);

  @override
  State<DocSlider> createState() => _DocSliderState();
}

class _DocSliderState extends State<DocSlider> {
  List<DocumentLists> docList = [];

  void fetchPlaylist() {
    final args = (ModalRoute.of(context)!.settings.arguments as Map);
    final playlist = args["playlist"] as Playlist;

    exeFetch(uri: "/api/user/study_materials/").then((body) {
      final data = jsonDecode(body["body"])["data"] as List;
      shared_logger.d(data);
      setState(() {
        docList = data.map((doc) {
          return DocumentLists(
            id: doc["_id"],
            title: doc["title"],
            description: doc["description"],
            createdBy: doc["created_by_user"],
            linkToBookCoverImage: doc["link_to_book_cover_image"],
            linkToDocument: doc["link_to_doc_file"],
            price: doc["price"],
            paid: args["paid"],
          );
        }).toList();
      });
      shared_logger.d(docList);
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPlaylist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...docList.asMap().entries.map((item) {
          final doc = item.value;
          return Padding(
            padding: EdgeInsets.only(top: item.key == 0 ? 0 : 20),
            child: GestureDetector(
              child: SizedBox(
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          "assets/images/course.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.title.toString(),
                            style: const TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFF6750A3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            doc.createdBy.toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFFFF0099),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}
