
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ottu_flutter_sdk/delegates/payment_delegate.dart';
import 'dart:convert';

import 'enums/enums.dart';
import 'enums/enums.dart';
import 'enums/enums.dart';
import 'enums/enums.dart';
import 'enums/enums.dart';
import 'models/payment_item.dart';
import 'enums/enums.dart';
import 'package:meta/meta.dart';


class OttuFlutterSdk {
  static const channel_name = 'ottu_flutter_sdk';
  static const MethodChannel _channel = const MethodChannel(channel_name);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('version');
    return version;
  }

  static Future<void> performPayment({@required CountryCode countryCode, @required List<PaymentCard> paymentCards,
    @required List<PaymentItem> paymentItems, @required double paymentAmount, @required CurrencyCode currencyCode,
    @required String merchantID, @required String domain, @required String sessionId, @required String code})

  async {

    final String version = await _channel.invokeMethod('payment',
        [
          countryCode.getRawValue,
          paymentCards.map((e) => e.getRawValue).toList(),
          jsonEncode(paymentItems),
          paymentAmount,
          currencyCode.getRawValue,
          merchantID,
          domain,
          sessionId,
          code,
        ]
    );
  }

  static void setPaymentDelegate(PaymentDelegate delegate) => _channel.setMethodCallHandler((MethodCall methodCall) async {
    switch(methodCall.method){
      case "paymentFinished":
        delegate.paymentFinished(methodCall.arguments as bool);
        break;
      case "paymentDissmised":
        delegate.paymentDismissed();
        break;
      case "paymentInfo":
        PaymentStatus status = PaymentStatusHelper.fromString(methodCall.arguments as String);
        delegate.paymentInfo(status);
        break;
      default:
        print("error");
    }
  });


}
