//
//  TicketView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/13/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct TicketView: View {
    let ticket: Ticket
    
    var body: some View {
        VStack(spacing: 16) {
            // Event Name
            Text(ticket.eventName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            // QR Code Image centered
            HStack {
                Spacer()
                if let url = URL(string: ticket.qrCodeURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit() // Maintain aspect ratio without stretching
                            .frame(width: 200, height: 200) // Display at its natural size or smaller
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                } else {
                    // Placeholder if URL is invalid
                    Image(systemName: "qrcode")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                Spacer()
            }
            .padding(.top, 8)
            
            // Ticket Details
            VStack(alignment: .leading, spacing: 8) {
                // Display Guest's Name
               Text("Guest: \(ticket.user?.fullname ?? "Unknown Guest")")
                   .font(.headline)

                Text("Price: $\(ticket.price, specifier: "%.2f")")
                    .font(.headline)
                
                Text("Date & Time: \(ticket.dateTime.formatted(.dateTime.month().day().hour().minute()))")
                    .font(.headline)
                
                Text("Address: \(ticket.address)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
            
            // Validity Status
            Text(ticket.valid ? "Valid" : "Invalid")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(ticket.valid ? .green : .red)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Ticket")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView(ticket: dev.ticket)
    }
}


