//
//  InviteCreationView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI

struct CreateEventView: View {
    @StateObject var viewModel = CreateEventViewModel()
    @State private var caption = ""
    @State private var price: Float = 0.0
    @Environment (\.dismiss) var dismiss
    
    private var user: User? {
        return UserService.shared.currentUser
    }
    
    private var numberFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return formatter
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top){
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.username ?? "")
                            .fontWeight(.semibold)
                        
                        TextField("Launch an event...", text: $caption, axis: .vertical)
                        TextField("Ticket Price: ", value: $price, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                Spacer()
            }
            .padding()
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            try await viewModel.uploadEvent(caption: caption, price: price)
                            dismiss()
                        }
                    }
                    .opacity(caption.isEmpty ? 0.5 : 1.0)
                    .disabled(caption.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }

}
