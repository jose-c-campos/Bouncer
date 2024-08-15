//
//  CheckoutView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//
import SwiftUI
import Stripe

struct CheckoutView: View {
    let event: Event
    @StateObject private var viewModel = CheckoutViewModel()
    @State private var message: String = ""
    @State private var paymentSuccess: Bool = false
    @State private var paymentMethodParams: STPPaymentMethodParams?
    @State private var isNavigatingToTicket = false
    @State private var isProcessingPayment = false // State to track if payment is processing
    let paymentGatewayController = PaymentGatewayController()
    
    private var user: User? {
        return UserService.shared.currentUser
    }

    func pay(for event: Event) {
        guard let clientSecret = PaymentConfigService.shared.paymentIntentClientSecret else { return }
        
        isProcessingPayment = true // Start processing
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        paymentGatewayController.submitPayment(intent: paymentIntentParams) { status, intent, error in
            
            DispatchQueue.main.async {
                isProcessingPayment = false // Stop processing
                
                switch status {
                    case .failed:
                        message = "Payment Failed"
                    case .canceled:
                        message = "Payment Cancelled"
                    case .succeeded:
                        message = "Your payment has been successfully completed"
                        paymentSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isNavigatingToTicket = true
                        }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(event.name)
                    .font(.headline)
                    .padding(.top, 12)
                
                if let imageUrl = event.imageURL, let url = URL(string: imageUrl) {
                    GeometryReader { geometry in
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.width * 0.6)
                        }
                    }
                    .frame(height: 250)
                    .cornerRadius(10)
                    .padding()
                }
                
                Text("Price: $\(event.price, specifier: "%.2f")")
                    .font(.title2)
                
                Section {
                    STPPaymentCardTextField
                        .Representable
                        .init(paymentMethodParams: $paymentMethodParams)
                } header: {
                    Text("Payment Information")
                }
                
                NavigationLink(
                    destination: TicketCreationView(
                        viewModel: TicketCreationViewModel(
                            event: event
                        )
                    ), isActive: $isNavigatingToTicket
                ) {
                    EmptyView()
                }
                
                Button("Get Tickets") {
                    viewModel.startCheckout(for: event) { success in
                        if success {
                            pay(for: event)
                        } else {
                            message = "Failed to initiate Checkout"
                        }
                    }
                }
                .padding()
                
                Text(message)
                
                Spacer()
            }
            .navigationTitle("Checkout")
            
            // Show the loader when payment is being processed
            if isProcessingPayment {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                    Text("Processing Payment...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
    
struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(event: dev.event)
    }
}
