//
//  CreateEventViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation
import Firebase
import FirebaseAuth

class CreateEventViewModel: ObservableObject {
    
    func uploadEvent(caption: String, price: Float) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let event = Event(
            ownerUid: uid,
            caption: caption,
            timestamp: Timestamp(),
            price: price,
            likes: 0
            
        )
        try await EventService.uploadEvent(event)
    }
}
