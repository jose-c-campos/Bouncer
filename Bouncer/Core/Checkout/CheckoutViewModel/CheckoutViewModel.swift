//
//  CheckoutViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import Stripe

struct CheckoutViewModel {
    
    init() {
        StripeAPI.defaultPublishableKey = "pk_test_51PmpxNKUAUBsLSp5kWVvdSq5oS6uOA51QoFAyN6WLLEIlPRwcqrlA5wLyYCL24buCNXanQp6B1pwZt4G2cmMw2Ug00TBynO4sy"
    }
}
