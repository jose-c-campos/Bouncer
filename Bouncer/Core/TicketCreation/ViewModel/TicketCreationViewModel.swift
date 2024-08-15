//
//  TicketViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import Combine
import Firebase
import FirebaseAuth
import SwiftUI

class TicketCreationViewModel: ObservableObject {
    @Published var QRCodeImage : UIImage?
    @Published var currentUser: User?
    
    let event: Event
    private var cancellables = Set<AnyCancellable>()
    
    init(event: Event) {
        self.event = event
        setUpSubscribers { [weak self] in
            self?.generateTicket()
        }
    }
    
    // Function sets up current user
    private func setUpSubscribers(completion: @escaping () -> Void) {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
            if user != nil {
                print("completion")
                completion()
            }
        }
        .store(in: &cancellables)
    }
    
    func generateTicket() {
        guard let userID = currentUser?.id else {
            print("User is nil")
            return
        }
        //    Event: \(eventName), User: \(username)
        let qrText = "EventID: \(event.id), EventOwnerID: \(event.ownerUid), TicketOwnerID: \(userID)"
        
        print("QRText: \(qrText)")
        if let pngData = generateQRCode(text: qrText) {
            print(pngData)
            QRCodeImage = UIImage(data: pngData)
            Task {
                if let qrCodeURL = try await uploadTicketImage() {
                    try await uploadTicket(qrCodeURL: qrCodeURL)
                } else {
                    print("Failed to upload QR code image")
                }
            }
        }
    }
        
    private func generateQRCode(text: String) -> Data? {
        let filter = CIFilter.qrCodeGenerator()
        
        print("Encoding Text: \(text)")
        
        let data = Data(text.utf8)
        print("Encoded Data: \(data)")
        
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let qrcodeImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                let uiImage = UIImage(ciImage: outputImage)
                return uiImage.pngData()
            }
        }
        return (UIImage(systemName: "XMark") ?? UIImage()).pngData()
    }

    
    // Method to upload the event image
    func uploadTicketImage() async throws -> String? {
        let path = "ticket_QR_Code_images"
        guard let image = QRCodeImage else { return nil }
        guard let imageUrl = try? await ImageUploader.uploadTicketImage(image, path: path) else { return nil }
        return imageUrl
    }
    
    func uploadTicket(qrCodeURL: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ticket = Ticket(
            eventId: event.id,
            eventOwnerUid: event.ownerUid,
            ticketOwnerUid: uid,
            eventName: event.name,
            price: event.price,
            dateTime: event.dateTime,
            address: event.address,
            qrCodeURL: qrCodeURL,
            timestamp: Timestamp(),
            valid: true
        )
        try await TicketService.uploadTicket(ticket)
    }
}
