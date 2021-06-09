# OTTU Flutter Plugin


[![License](https://img.shields.io/cocoapods/l/OttuCheckout.svg?style=flat)](https://cocoapods.org/pods/OttuCheckout)

[![Platform](https://img.shields.io/cocoapods/p/OttuCheckout.svg?style=flat)](https://cocoapods.org/pods/OttuCheckout)

  

## Example

  

To run the example project, clone the repo, and run `flutter pub get` in the main repository folder, make sure you have iOS simulator or device already plugged in, and run `flutter run` from the Example directory.

  

## Requirements

- Flutter 1.22.6 or greater
- Dart 1.19.0 or greater
- iOS 12.1 or greater

## Installation

  
### pub.dev

OTTU Flutter Plugin is available through [pub.dev](https://cocoapods.org). To install

it, simply add the following lines to your pubspec.yaml:

  

```ruby

dependencies:
flutter:
  sdk: flutter

ottu_flutter_sdk: ^0.0.1+9

```

  
### manually
OTTU Flutter Plugin can be installed manually by adding the following lines to your pubspec.yaml:

  

```ruby

dependencies:
flutter:
  sdk: flutter

ottu_flutter_sdk:
  path: /path/to/flutter_ottu_checkout


```


## Using

    

#### Integrate with Xcode

Add the ****Apple Pay**** capability to your app. In Xcode, open your project settings, choose the ****Capabilities**** tab, and enable the ****Apple Pay**** switch. You may be prompted to log in to your developer account at this point. Enable the checkbox next to the merchant ID you created earlier, and your app is ready to accept Apple Pay.

![Enable the Apple pay capability in Xcode](https://storage.stfalcon.com/uploads/images/5c45cffa7e8f6.png)

### Setup

in your working `dart` file

  

After installing the plugin from Pub.dev or manually you will need to import the used package classes

```

import 'package:ottu_flutter_sdk/models/payment_item.dart';
import 'package:ottu_flutter_sdk/ottu_flutter_sdk.dart';
import 'package:ottu_flutter_sdk/enums/enums.dart';
import 'package:ottu_flutter_sdk/delegates/payment_delegate.dart';

```

Then implement the sdk delegate like this

```

class _MyHomePageState extends State<MyHomePage> implements PaymentDelegate {

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

```

After this you can config apple pay request like this

```

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

```
All of the parameters are mandetory and not nullable

| Name | Type |  Description | Example Value|
|--|--|--|--|
|countryCode| CountryCode enum| The two-letter ISO 3166 country code. | CountryCode.SA|
|paymentCards| List of PaymentCard enum| List of available payment methods that are supported by Apple Pay.| [PaymentCard.Visa]|
|paymentItems| List of PaymentItem class| An array of payment summary item objects that summarize the amount of the payment.| [PaymentItem("Potato", 3.2)] |
|paymentAmount| double| The sum to pay| .01|
|currencyCode| CurrencyCode enum| The three-letter ISO 4217 currency code.| CurrencyCode.SAR|
|merchantID| String| Your merchant identifier.| merchant.dev.ottu.ksa|
|domain| String| API pay url, where payment shall be confirmed against Apple Pay token|"ksa.ottu.dev"|
|sessionId| String| Specified token which you need to get here https://docs.ottu.com/#/sessionAPI| "34e097cbe7a1b358628bb4b8e183083ffa78af9c"|
|code| String| A string code to idetify the operation|"apple-pay"|







  ### Delegate
  You need to delegate PaymentDelegate 
```

OttuFlutterSdk.setPaymentDelegate(this);

```
Then implement PaymentDelegate protocol to your Class

```

class MyClass implements PaymentDelegate {

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

```

PaymentStatus can be one of the following values

```

switch (status) {

    case .Eligible:
    break;
    case .NeedSetup:
    break;
    case .NotEligible:
    break;
    case .SessionIDNotSetuped:
    break;
    case .DomainURLNotSetuped:
    break;
    case .CodeNotSetuped:
    break;
}

```

  

## Author

  

Ottu,    [Info@ottu.com](mailto:Info@ottu.com)

  

## License

  

OttuCheckout is available under the MIT license. See the LICENSE file for more info.

