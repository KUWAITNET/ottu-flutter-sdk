//
//  PaymentViewController.swift
//  ottu_flutter_sdk
//
//  Created by Saad on 5/10/21.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {

    
    // MARK: entered by the user
    var countryCode:CountryCode = .SA
    var paymentCards:[TapApplePayPaymentNetwork] = [.Visa,.Amex,.MasterCard]
    var paymentItems:[PKPaymentSummaryItem] = []
    var paymentAmount:Double = 0.1
    var currencyCode:CurrencyCode = .SRD
    var merchantID:String = ""
    var domain:String = ""
    var sessionID:String = ""
    var code:String = ""
    
    
    var channel:FlutterMethodChannel?
    
    
    
    @IBOutlet weak var applePayView:UIView!
    
    @IBOutlet weak var lblDesc:UILabel!

    
    

    var checkout = Checkout()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: Configure the sdk
        
        checkout.delegate = self
        
        let config = ApplePayConfig()
        config.merchantID = merchantID
        config.cards = paymentCards
        config.countryCode = countryCode
        config.merchantCapabilities = [.capability3DS]
        config.paymentItems = paymentItems
        
        self.checkout.sessionID = sessionID
        self.checkout.domainURL = domain
        self.checkout.code = code
        self.checkout.configure(applePayConfig: config, amount: String(paymentAmount), currency_code: currencyCode, viewController: self)

        
        
//        checkout.configure(with: countryCode, paymentNetworks: paymentNetworks, paymentItems: paymentItems, paymentAmount: paymentAmount, currencyCode: currencyCode, merchantID: merchantID, domain: domain)
//        checkout.displayApplePayButton(applePayView: applePayView)
        
        
        let result = self.checkout.displayApplePayButton(applePayView: applePayView)
        switch result {
        case .Eligible:
            channel?.invokeMethod("paymentInfo", arguments: "Eligible")
            break
        case .NeedSetup:
            channel?.invokeMethod("paymentInfo", arguments: "NeedSetup")
            break
        case .NotEligible:
            channel?.invokeMethod("paymentInfo", arguments: "NotEligible")
            break
        case .SessionIDNotSetuped:
            channel?.invokeMethod("paymentInfo", arguments: "SessionIDNotSetuped")
            break
        case .DomainURLNotSetuped:
            channel?.invokeMethod("paymentInfo", arguments: "DomainURLNotSetuped")
            break
        }
        
        
        lblDesc.text = "You are about to pay \(paymentAmount) \(currencyCode.appleRawValue)"
        
    }
    
//    @IBAction func addApplePAyBtn(_ sender:UIButton) {
//        checkout.displayApplePayButton(applePayView: applePayView)
//    }




}


extension PaymentViewController: CheckoutDelegate {
        
    func paymentFinished(yourDomainResponse: [String:Any], applePayResultCompletion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        

        
        if let approved = yourDomainResponse["approved"], approved as! Bool == true {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            channel?.invokeMethod("paymentFinished", arguments: true)

        }
        else {
            applePayResultCompletion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            channel?.invokeMethod("paymentFinished", arguments: false)

        }
    }
    
    
    func paymentDissmised() {
        channel?.invokeMethod("paymentDissmised", arguments: nil)

        //
    }
}
