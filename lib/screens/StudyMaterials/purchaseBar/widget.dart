import 'dart:convert';

import 'package:cca_vijayapura/screens/StudyMaterials/docSlider/widget.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class StudyMaterialPurchaseSummaryView extends StatefulWidget {
  final List<DocumentLists> selectedStudymaterials;
  final Function() reloadSubscriptionStatus;
  const StudyMaterialPurchaseSummaryView({
    Key? key,
    required this.selectedStudymaterials,
    required this.reloadSubscriptionStatus,
  }) : super(key: key);

  @override
  State<StudyMaterialPurchaseSummaryView> createState() =>
      _StudyMaterialPurchaseSummaryViewState();
}

class _StudyMaterialPurchaseSummaryViewState
    extends State<StudyMaterialPurchaseSummaryView> {
  Map orderData = {};

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // showAlertDialog(context, "Payment Successful",
    //     "Payment ID: ${response.paymentId},${response.orderId},${response.signature}");
    verifyPaymentStatus();
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  InvokePaymentGateway({required String orderId, required int amount}) {
    final int totalPrice = widget.selectedStudymaterials
        .fold(0, (previous, current) => previous + current.price);
    if (amount != totalPrice) {
      ToastMessage.error("amount mismatch");
      return;
    }
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_H8OTCJN1OWNZcp',
      "order_id": orderId,
      'amount': totalPrice * 100,
      'name': 'CCA Vijayapura',
      'description': 'Study material',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void verifyPaymentStatus() {
    exeFetch(
      uri:
          """/api/user/confirm_payment_for_study_material_subscription/?order_id=${orderData["_id"]}""",
    ).then((body) {
      final data = jsonDecode(body["body"])["data"];
      shared_logger.d(data);
      if (data["payment_status"]) {
        ToastMessage.success("payment success");
      } else {
        ToastMessage.error("payment failed");
      }
      widget.reloadSubscriptionStatus();
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  void createOrder() {
    List<String> studyMaterials =
        widget.selectedStudymaterials.map((playlist) => playlist.id).toList();
    exeFetch(
      uri: "/api/user/enroll_to_study_material/",
      method: "post",
      body: jsonEncode({"document_ids": studyMaterials}),
    ).then((body) {
      final data = jsonDecode(body["body"])["data"];
      shared_logger.d(data);
      orderData = data;
      InvokePaymentGateway(orderId: data["order_id"], amount: data["amount"]);
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  void purchaseStudyMaterial() {
    createOrder();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedStudymaterials.isEmpty) {
      return const SizedBox();
    }

    final int totalPrice = widget.selectedStudymaterials
        .fold(0, (previous, current) => previous + current.price);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.green,
        // borderRadius: BorderRadius.circular(5.0),
        border: Border(
            top: BorderSide(
          color: Color.fromARGB(173, 69, 162, 74),
          width: 3,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected ${widget.selectedStudymaterials.length} Study materials",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 0,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    "Total price: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                    "$totalPrice",
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
            ],
          ),
          Column(children: [
            ElevatedButton(
              onPressed: purchaseStudyMaterial,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                ),
                backgroundColor: const MaterialStatePropertyAll<Color>(
                  Colors.white,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(
                        color: Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: const Text(
                "Proceed",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
