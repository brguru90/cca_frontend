import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:flutter/material.dart';

class DocumentLists {
  final String id, title, description, createdBy, category;
  final String linkToBookCoverImage, linkToDocument;
  final int price, blockSize;
  final DateTime lastUpdated;
  bool selectedForPurchase;

  DocumentLists({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.category,
    required this.linkToBookCoverImage,
    required this.linkToDocument,
    required this.price,
    required this.blockSize,
    required this.lastUpdated,
    this.selectedForPurchase = false,
  });
}

class DocSlider extends StatefulWidget {
  final List<DocumentLists> docList;
  final Map<String, String?> subscription;

  final void Function(int index) onPurchaseClick;
  const DocSlider(
      {Key? key,
      required this.docList,
      required this.onPurchaseClick,
      required this.subscription})
      : super(key: key);

  @override
  State<DocSlider> createState() => _DocSliderState();
}

class _DocSliderState extends State<DocSlider> {
  Widget purchaseSelectedStatus(
      {required Widget child, required bool selectedForPurchase}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: selectedForPurchase ? Colors.green : Colors.white,
          width: 2,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    String FullURI =
        """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""";

    return Column(
      children: [
        ...widget.docList.asMap().entries.map((item) {
          final doc = item.value;
          final imagePreviewUrl = "$FullURI${doc.linkToBookCoverImage}";
          return Padding(
            padding: EdgeInsets.only(top: item.key == 0 ? 0 : 20),
            child: GestureDetector(
              child: SizedBox(
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        if (widget.subscription[item.value.id] != null)
                          {
                            Navigator.pushNamed(
                              context,
                              '/doc_viewer',
                              arguments: doc,
                            )
                          }
                        else
                          {ToastMessage.info("Please purchase before view")}
                      },
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/loading.png",
                            image: imagePreviewUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IntrinsicHeight(
                      // flex: 1,
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
                          Text(
                            doc.category,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF6750A3),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          ...(() {
                            if (widget.subscription[item.value.id] == null) {
                              return [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          widget.onPurchaseClick(item.key),
                                      child: purchaseSelectedStatus(
                                        selectedForPurchase:
                                            doc.selectedForPurchase,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Buy for ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  wordSpacing: 0,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                                child: Icon(
                                                  Icons.currency_rupee,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ),
                                              Text(
                                                "${doc.price}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  wordSpacing: 0,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ];
                            }
                            return [const SizedBox()];
                          })(),
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
