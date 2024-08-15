//
//  TicketView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import SwiftUI

struct TicketCreationView: View {
    @StateObject var viewModel: TicketCreationViewModel
    private var currentUser: User? {
        return viewModel.currentUser
    }
    var body: some View {
        VStack {
            if let qrCodeImage = viewModel.QRCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 200, height: 200)
                    .cornerRadius(5)
                    .padding()
            } else {
                Text("Generating QR Code")
            }
            
            Text("Ticket to \(viewModel.event.name)")
                .font(.title)
                .padding(.top, 16)
            if let username = currentUser?.username {
                Text("Ticketholder: \(username)")
                    .font(.subheadline)
                    .padding(.top, 8)
            } else {
                Text("Username not available")
                    .font(.subheadline)
                    .padding(.top, 8)
            }
            
                        
            Spacer()
        }
        .padding()
        .navigationTitle("Your Ticket")
    }
}


struct TicketCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TicketCreationViewModel(event: dev.event)
        TicketCreationView(viewModel: viewModel)
    }
}
