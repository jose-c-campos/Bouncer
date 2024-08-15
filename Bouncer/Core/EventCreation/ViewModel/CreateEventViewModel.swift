//
//  CreateEventViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI
import PhotosUI

class CreateEventViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    
    @Published var eventImage: Image?
       
    // Must use UIImage for uploading, not SwiftUI Image
    private var uiImage: UIImage?
    
    // Method to load the selected image
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.eventImage = Image(uiImage: uiImage)
    }
    
    // Method to upload the event image
    func uploadEventImage() async throws -> String? {
        let path = "event_images"
        guard let image = self.uiImage else { return nil }
        guard let imageUrl = try? await ImageUploader.uploadImage(image, path: path) else { return nil }
        return imageUrl
    }
    
    func uploadEvent(name: String, dateTime: Date, address: String, price: Float, caption: String, imageURL: String?) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let event = Event(
            ownerUid: uid,
            name: name,
            dateTime: dateTime,
            address: address,
            price: price,
            caption: caption,
            imageURL: imageURL,
            timestamp: Timestamp(),
            likes: 0
        )
        try await EventService.uploadEvent(event)
    }
}
