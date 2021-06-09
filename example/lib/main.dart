import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';


import 'package:ottu_flutter_sdk/models/payment_item.dart';
import 'package:ottu_flutter_sdk/ottu_flutter_sdk.dart';
import 'package:ottu_flutter_sdk/enums/enums.dart';
import 'package:ottu_flutter_sdk/delegates/payment_delegate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ottu Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Ottu Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements PaymentDelegate {
  final TextEditingController _codeTextController = TextEditingController();
  final TextEditingController _sessionIdTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();


  void _makePayment() async {
    print(_codeTextController.text);
    print(_sessionIdTextController.text);
    print(_amountTextController.text);

    FocusScope.of(context).unfocus();

    OttuFlutterSdk.setPaymentDelegate(this);

    await OttuFlutterSdk.performPayment(
        countryCode: CountryCode.SA,
        paymentCards: [PaymentCard.Visa, PaymentCard.Amex, PaymentCard.MasterCard],
        paymentItems: [PaymentItem("Potato", 3.2), PaymentItem("Tomato", 4.1)],
        paymentAmount: double.tryParse(_amountTextController.text) ?? 0.1,
        currencyCode: CurrencyCode.SAR,
        merchantID: "merchant.dev.ottu.ksa",
        domain: "ksa.ottu.dev",
        sessionId: _sessionIdTextController.text,
        code: _codeTextController.text,
    );

  }

  void toast(String str){

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content:
    //         Text(str),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Apple pay sample",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _codeTextController..text="apple-pay",
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code',
                    hintText: 'apple-pay',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: null,
                  controller: _sessionIdTextController..text="34e097cbe7a1b358628bb4b8e183083ffa78af9c",
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Session ID',
                    hintText: '34c0',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _amountTextController..text="0.1",
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                    hintText: '0.1',
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _makePayment,
        tooltip: 'Make Payment',
        child: Icon(Icons.attach_money),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  @override
  void paymentDismissed() {
    print("Payment dismissed");
    toast("Payment dismissed");

  }

  @override
  void paymentFinished(bool idApproved) {
    print("Payment finished");
    toast("Payment finished");
  }

  @override
  void paymentError(int statusCode, String serverResponse){
    print("Status Code $statusCode");
    toast("Status Code $statusCode");
  }

  @override
  void paymentInfo(PaymentStatus status) {
    print(status.getDescription);
    toast(status.getDescription);
  }


}
