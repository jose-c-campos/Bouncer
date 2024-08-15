//
//  PaymentConfigService.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation

class PaymentConfigService {
    
    var paymentIntentClientSecret: String?
    static var shared: PaymentConfigService = PaymentConfigService()
    
    private init() { }
}
