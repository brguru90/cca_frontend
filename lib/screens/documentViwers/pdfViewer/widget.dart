import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cca_vijayapura/screens/StudyMaterials/docSlider/widget.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/services/utils.dart';
import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;

class PDFViwerWrap extends StatefulWidget {
  // final String fileURL;
  // final DocumentLists doc;
  const PDFViwerWrap({Key? key}) : super(key: key);

  @override
  State<PDFViwerWrap> createState() => _PDFViwerWrapState();
}

class _PDFViwerWrapState extends State<PDFViwerWrap> {
  String? filePath;
  Uint8List? pdfData;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  Future<String> getFileDecryptionKey(String docId) {
    Completer<String> c = Completer<String>();
    exeFetch(
      uri: "api/user/get_doc_key/?doc_id=$docId",
      method: "post",
      body: jsonEncode({
        "app_id": const String.fromEnvironment("APP_ID"),
      }),
    ).then((body) {
      final data = jsonDecode(body["body"])["data"];
      shared_logger.d(data);
      final decryptedValue = DecryptAES(
          const String.fromEnvironment("APP_SECRET"),
          data["block_size"],
          data["key"]);
      shared_logger.d(decryptedValue);
      c.complete(decryptedValue);
    }).catchError((err) {
      shared_logger.e(err);
      ToastMessage.error("unable to fetch file");
      c.completeError("error");
    });
    return c.future;
  }

  Uri FullURI = Uri.parse(
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""");

  Future<String> fetchDocFile(String fileURL) {
    Completer<String> c = Completer<String>();

    http.get(Uri.parse("$FullURI$fileURL")).then((response) {
      c.complete(response.body);
    }).catchError((err) {
      shared_logger.e(err);
      ToastMessage.error("unable to fetch file");
      c.completeError("error");
    });
    return c.future;
  }

  getFile() async {
    final doc = ModalRoute.of(context)!.settings.arguments as DocumentLists;

    List<Future> futures = [
      getFileDecryptionKey(doc.id),
      fetchDocFile(doc.linkToDocument),
    ];
    Future.wait(futures).then((values) {
      String decryptionKey = values[0];
      String fileBytes = values[1];

      final decryptedBytes =
          DecryptAES(decryptionKey, doc.blockSize, fileBytes);
      final Uint8List fileBytes0 = Uint8List.fromList(decryptedBytes.codeUnits);
      var s = fileBytes0.buffer
          .asUint8List()
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join(" ");

      setState(() {
        pdfData = fileBytes0;
      });
      final plain = String.fromCharCodes(pdfData!);
      shared_logger.d(plain);
      shared_logger.d(s);

      // File file = MemoryFileSystem().file('test.pdf')
      //   ..writeAsBytesSync(Uint8List.fromList(decryptedBytes.codeUnits));
    }).catchError((err) {
      shared_logger.e(err);
      ToastMessage.error("unable to fetch file");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFile();
    });
  }

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    if (pdfData == null) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            child: const Text("Loading"),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 26, 30, 28),
          width: double.infinity,
          height: double.infinity,
          child: PDFView(
            pdfData: pdfData,
            enableSwipe: false,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            onRender: (pages) {
              setState(() {
                pages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              shared_logger.e(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              shared_logger.e('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              shared_logger.d('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
        ),
      ),
    );
  }
}
