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

        
        presentViewController(with: countryCode!, paymentCards:paymentCards, paymentItems: paymentItems, paymentAmount: paymentAmount, currencyCode: currencyCode!, merchantID: merchantID, domain: domain, sessionID: sessionId, code: code)
        result("payment")
        
        
    default:
        result(FlutterMethodNotImplemented)
     
    }

    
}
    
    
    func presentViewController(with countryCode:CountryCode, paymentCards:[TapApplePayPaymentNetwork], paymentItems:[PKPaymentSummaryItem], paymentAmount:Double, currencyCode:CurrencyCode, merchantID:String, domain:String, sessionID:String, code:String){
        
        
        let bundle = Bundle(identifier: "org.cocoapods.ottu-flutter-sdk")
        let viewController = PaymentViewController(nibName: "PaymentViewController", bundle: bundle)
        viewController.currencyCode = currencyCode
        viewController.paymentCards = paymentCards
        viewController.paymentItems = paymentItems
        viewController.paymentAmount = paymentAmount
        viewController.currencyCode = currencyCode
        viewController.merchantID = merchantID
        viewController.domain = domain
        viewController.sessionID = sessionID
        viewController.code = code
        
        viewController.channel = SwiftOttuFlutterSdkPlugin.channel

        let rootViewController:UIViewController! = UIApplication.shared.keyWindow?.rootViewController
        if (rootViewController is UINavigationController) {
            (rootViewController as! UINavigationController).pushViewController(viewController,animated:true)
        } else {
            let navigationController:UINavigationController! = UINavigationController(rootViewController:viewController)
          rootViewController.present(navigationController, animated:true, completion:nil)
        }
    }
    
}
