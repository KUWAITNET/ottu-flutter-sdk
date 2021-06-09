import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ottu_flutter_sdk/models/payment_item.dart';
import 'package:ottu_flutter_sdk/ottu_flutter_sdk.dart';
import 'package:ottu_flutter_sdk/enums/enums.dart';
import 'package:ottu_flutter_sdk/delegates/payment_delegate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements PaymentDelegate {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

    OttuFlutterSdk.setPaymentDelegate(this);
  }

  Future<dynamic> myUtilsHandler(MethodCall methodCall) async {
    //method values are 'status', 'finished', 'dismissed'
    print(methodCall.method);
  }

  void _getVersion() async {
    String platformVersion;

    try {
      platformVersion = await OttuFlutterSdk.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _performPayment() async {

    //empty arrays should work, but none of the values could be null!

    await OttuFlutterSdk.performPayment(
        countryCode: CountryCode.SA,
        paymentCards: [PaymentCard.Visa, PaymentCard.Amex, PaymentCard.MasterCard],
        paymentItems: [PaymentItem("Potato", 3), PaymentItem("Tomato", 4)],
        paymentAmount: 125.64,
        currencyCode: CurrencyCode.SRD,
        merchantID: "merchant.kbsoft.example",
        domain: "https://ksa.ottu.dev",
        sessionId: "sessionId",
        code: "code"
    );

    setState(() {
      _platformVersion = "payment";
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(onPressed: _getVersion, child: Text("Version")),
              ElevatedButton(onPressed: _performPayment, child: Text("Payment")),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void paymentDismissed() {
    print("Payment dismissed");
  }

  @override
  void paymentFinished(bool idApproved) {
    print("Payment finished");
  }

  @override
  void paymentInfo(PaymentStatus status) {
    print(status.getDescription);
  }

  @override
  void paymentError(int statusCode, String serverResponse){
    print("Status Code $statusCode");

  }
}

