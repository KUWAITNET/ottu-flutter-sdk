//
//  PaymentItem.swift
//  ottu_flutter_sdk
//
//  Created by Saad on 5/12/21.
//

import Foundation

class PaymentItem : Codable {
    var label:String?
    var amount:Double?
    
    init(label:String, amount:Double) {
        self.label = label
        self.amount = amount
    }
    
    init(json:String) {
        let item = PaymentItem.fromJson(jsonData: json)
        label = item.label
        amount = item.amount
    }
    
    static func fromJson(jsonData:String)->PaymentItem{
        let jsonDecoder = JSONDecoder()
        return try! jsonDecoder.decode(PaymentItem.self, from: jsonData.data(using: .utf8)!)
    }
    
    static func fromJsonArray(jsonData:String)->[PaymentItem]{
        let jsonDecoder = JSONDecoder()
        return try! jsonDecoder.decode([PaymentItem].self, from: jsonData.data(using: .utf8)!)
    }
    
    func toJson() -> String?{
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self)
        return String(data: jsonData , encoding: String.Encoding.utf8)
        
       
    }
    
}
