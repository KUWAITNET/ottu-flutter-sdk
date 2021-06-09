//
//  SwiftOttuFlutterSdkPlugin.swift
//  Ottu Flutter SDK
//
//  Created by Saad Alkentar on 12/5/21.
//  Copyright © 2020 Saad. All rights reserved.
//

import Flutter
import UIKit
import PassKit


public class SwiftOttuFlutterSdkPlugin: NSObject, FlutterPlugin {
    
    static let channelName = "ottu_flutter_sdk"
    static var channel:FlutterMethodChannel?
        
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = SwiftOttuFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "version":
        print("version request")
        result("iOS \(UIDevice.current.systemVersion)")
    case "payment":
        print("payment request")
        let args = call.arguments as! [Any]
        guard args.count == 9 else {
            result("not enough arguments")
            return
        }
        
        let countryCode = CountryCode(rawValue: args[0] as! String)
        let lstCards = args[1] as! [String]
        let paymentCards = lstCards.map {  TapApplePayPaymentNetwork(rawValue: $0)! }
        
        let lstItemsPayment = PaymentItem.fromJsonArray(jsonData: args[2] as! String)
        let paymentItems:[PKPaymentSummaryItem] = lstItemsPayment.map{ PKPaymentSummaryItem(label: $0.label!, amount: NSDecimalNumber(floatLiteral: $0.amount!))}
        let paymentAmount = args[3] as! Double
        let currencyCode = CurrencyCode(appleRawValue: args[4] as! String)
        let merchantID = args[5] as! String
        let domain = args[6] as! String
        let sessionId = args[7] as! String
        let code = args[8] as! String

        
        presentViewController(with: countryCode!, paymentCards:paymentCards, paymentItems: paymentItems, paymentAmount: paymentAmount, currencyCode: currencyCode!, merchantID: merchantID, domain: domain, sessionID: sessionId,code: code)
        result("payment")
        
        
    default:
        result(FlutterMethodNotImplemented)
     
    }

    
}
    
    var checkout = Checkout()
    
    func presentViewController(
        with countryCode:CountryCode,
        paymentCards:[TapApplePayPaymentNetwork],
        paymentItems:[PKPaymentSummaryItem],
        paymentAmount:Double,
        currencyCode:CurrencyCode,
        merchantID:String,
        domain:String,
        sessionID:String,
        code:String){
        
        

        let rootViewController:UIViewController! = UIApplication.shared.keyWindow?.rootViewController
        
        
        let config = ApplePayConfig()
        config.merchantID = merchantID
        config.cards = paymentCards
        config.countryCode = countryCode
        config.merchantCapabilities = [.capability3DS]
        config.paymentItems = paymentItems
        config.code = code

        self.checkout.delegate = self
        self.checkout.sessionID = sessionID
        self.checkout.domainURL = domain
        self.checkout.configure(applePayConfig: config, amount: String(paymentAmount), currency_code: currencyCode, viewController: rootViewController)
        let result = self.checkout.pay(viewController: rootViewController)

        switch result {
        case .Eligible:
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentInfo", arguments: "Eligible")
            break
        case .NeedSetup:
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentInfo", arguments: "NeedSetup")
            break
        case .NotEligible:
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentInfo", arguments: "NotEligible")
            break
        case .SessionIDNotSetuped:
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentInfo", arguments: "SessionIDNotSetuped")
            break
        case .DomainURLNotSetuped:
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentInfo", arguments: "DomainURLNotSetuped")
            break
        case .CodeNotSetuped:
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentInfo", arguments: "CodeNotSetuped")
        }
        
    }
    
}

extension SwiftOttuFlutterSdkPlugin : CheckoutDelegate{
    
    public func onErrorHandler(serverResponse: [String : Any]?, statusCode: Int?, error: Error?) {
        // Check any error from server
        
        let jsonData = try? JSONSerialization.data(withJSONObject: serverResponse ?? [:], options: [])
        let jsonString = String(data: jsonData!, encoding: String.Encoding.ascii)
        
        SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentError", arguments: [statusCode ?? 200, jsonString ?? "{}"])

    }
    
    public func paymentFinished(yourDomainResponse: [String:Any], applePayResultCompletion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        

        
        if let approved = yourDomainResponse["approved"], approved as! Bool == true {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentFinished", arguments: true)

        }
        else {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentFinished", arguments: false)

        }
    }
    
    
    public func paymentDissmised() {
        SwiftOttuFlutterSdkPlugin.channel?.invokeMethod("paymentDissmised", arguments: nil)

    }
    
}
