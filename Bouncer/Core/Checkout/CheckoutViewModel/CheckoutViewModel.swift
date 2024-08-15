//
//  CheckoutViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import Stripe

class CheckoutViewModel: ObservableObject {
    @Published var clientSecret: String?
    
    init() {
        StripeAPI.defaultPublishableKey = "pk_test_51PmpxNKUAUBsLSp5kWVvdSq5oS6uOA51QoFAyN6WLLEIlPRwcqrlA5wLyYCL24buCNXanQp6B1pwZt4G2cmMw2Ug00TBynO4sy"
    }
    
    func startCheckout(for event: Event, completion: @escaping (Bool) -> Void) {
        let url = URL(
            string: "https://reminiscent-plume-bard.glitch.me/create-payment-intent"
        )!
        
        let priceInCents = Int(event.price * 100)
        
        let eventPaymentInfo = EventPaymentInfo(eventName: event.name, price: priceInCents)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try? JSONEncoder().encode(eventPaymentInfo)
            print("JSON Data to be sent:", String(data: jsonData!, encoding: .utf8))
            request.httpBody = try JSONEncoder().encode(eventPaymentInfo)
        } catch {
            print("Failed to encode EventPriceInfo: \(error)")
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
            
            let checkoutIntentResponse = try?
                JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.clientSecret = checkoutIntentResponse?.clientSecret
                PaymentConfigService.shared.paymentIntentClientSecret = self.clientSecret
                completion(true)
            }
            
        }.resume()
    }
    
}

struct EventPaymentInfo: Codable {
    let eventName: String
    let price: Int
}
