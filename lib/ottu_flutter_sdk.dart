
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ottu_flutter_sdk/delegates/payment_delegate.dart';
import 'dart:convert';

import 'models/payment_item.dart';
import 'enums/enums.dart';


class OttuFlutterSdk {
  /// default channel name
  static const channel_name = 'ottu_flutter_sdk';

  /// default channel
  static const MethodChannel _channel = const MethodChannel(channel_name);

  /// this api is used for testing purposes only
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('version');
    return version;
  }

  /// Main function of the sdk, allows payment with all configurations
  /// 
  /// 
  /// countryCode: The two-letter ISO 3166 country code.
  /// paymentCards: List of available payment methods that are supported by Apple Pay.
  /// paymentItems: An array of payment summary item objects that summarize the amount of the payment.
  /// paymentAmount: The sum to pay
  /// currencyCode: The three-letter ISO 4217 currency code.
  /// merchantID: Your merchant identifier.
  /// domain: API pay url, where payment shall be confirmed against Apple Pay token
  /// sessionId: Specified token which you need to get here https://docs.ottu.com/#/sessionAPI
  /// code: A string code to idetify the operation
  /// 
  static Future<void> performPayment({
    @required CountryCode countryCode, 
    @required List<PaymentCard> paymentCards,
    @required List<PaymentItem> paymentItems,
    @required double paymentAmount, 
    @required CurrencyCode currencyCode,
    @required String merchantID, 
    @required String domain, 
    @required String sessionId, 
    @required String code
    }) async {

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

  /// Static function to set the payment delegate
  static void setPaymentDelegate(PaymentDelegate delegate) => _channel.setMethodCallHandler((MethodCall methodCall) async {
    switch(methodCall.method){
      case "paymentFinished":
        delegate.paymentFinished(methodCall.arguments as bool);
        break;
        
      case "paymentDissmised":
        delegate.paymentDismissed();
        break;

      case "paymentError":
        print("payment error");
        List<dynamic> args = methodCall.arguments as List<dynamic>;
        int statusCode = args[0] as int;
        String serverResponse = args[1] as String;
        delegate.paymentError(statusCode, serverResponse);
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
