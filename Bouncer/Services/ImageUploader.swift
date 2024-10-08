//
//  ImageUploader.swift
//  Bouncer
//
//  Created by Jose Campos on 8/9/24.
//

import Foundation
import Firebase
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(_ image: UIImage, path: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil } // Compresses large images
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/\(path)/\(filename)")
        
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadTicketImage(_ image: UIImage, path: String) async throws -> String? {
        guard let imageData = image.pngData() else { return nil } // Compresses large images
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/\(path)/\(filename)")
        
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
}
