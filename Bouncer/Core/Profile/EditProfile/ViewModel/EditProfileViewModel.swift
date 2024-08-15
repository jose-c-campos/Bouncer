//
//  EditProfileViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/9/24.
//

import Foundation
import SwiftUI
import PhotosUI

class EditProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    @Published var profileImage: Image?
    
    // Must use UI Image for uploading, not swiftUI Image
    private var uiImage: UIImage?
    
    func updateUserData() async throws {
        try await updateProfileImage()
    }
    
    // Funciton to Uplaod Profile Picture
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    // Calls Service: ImageUploader to update Profile Image
    private func updateProfileImage() async throws {
        let path = "profile_images"
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await ImageUploader.uploadImage(image, path: path) else { return }
        try await UserService.shared.updateUserProfileImage(withImageUrl: imageUrl)
    }

}
