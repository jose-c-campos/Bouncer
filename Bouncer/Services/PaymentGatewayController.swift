//
//  PaymentGatewayController.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import Stripe
import UIKit

class PaymentGatewayController: UIViewController {
    
    func submitPayment(intent: STPPaymentIntentParams, completion: @escaping
                       (STPPaymentHandlerActionStatus, STPPaymentIntent?, NSError?) -> Void) {
        let paymentHandler = STPPaymentHandler.shared()
        
        paymentHandler.confirmPayment(intent, with: self) {
            (status, intent, error) in
            completion(status, intent, error)
        }
    }
}

extension PaymentGatewayController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
