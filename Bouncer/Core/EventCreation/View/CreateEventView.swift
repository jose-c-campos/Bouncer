//
//  InviteCreationView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    var onPostComplete: (() -> Void)?
    @StateObject var viewModel = CreateEventViewModel()
    @State private var caption = ""
    @State private var name = ""
    @State private var dateTime = Date()
    @State private var address = ""
    @State private var price: Float = 0.0
    @State private var selectedImage: UIImage?
    @State private var imagePickerPresented = false
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
    
    // Function to clear all fields
    private func clearFields() {
        caption = ""
        name = ""
        dateTime = Date()
        price = 0.0
        address = ""
        viewModel.selectedItem = nil
        viewModel.eventImage = nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.username ?? "")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                
                // Event Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Name*")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    TextField("Enter the event name...", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.bottom, 20)
                
                // Event Caption Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Description")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    TextField("Describe your event...", text: $caption, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.bottom, 20)
                
                // Event Address Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Address*")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    TextField("Enter the event address...", text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.bottom, 20)
                
                // Event Date-Time Picker and Ticket Price Field
                HStack(spacing: 20) {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Event Date and Time*")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        DatePicker("", selection: $dateTime, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text("Ticket Price*")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        TextField("Enter price", value: $price, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 20)
                
                // Photos Picker for Event Image
                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Image")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    PhotosPicker(selection: $viewModel.selectedItem) {
                        if let image = viewModel.eventImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .frame(width: 200, height: 200)
                                .overlay(
                                    Text("Select Image")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                )
                        }
                    }
                
                }
                    
                Spacer()
            }
            .padding()
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            let imageURL = try await viewModel.uploadEventImage()
                            try await viewModel.uploadEvent(
                                name: name,
                                dateTime: dateTime,
                                address: address,
                                price: price,
                                caption: caption,
                                imageURL: imageURL
                            )
                            clearFields()
                            onPostComplete?()
                            dismiss()
                        }
                    }
                    .opacity(name.isEmpty || address.isEmpty || price <= 0.50 ? 0.5 : 1.0)
                    .disabled(name.isEmpty || address.isEmpty || price <= 0.50)
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
