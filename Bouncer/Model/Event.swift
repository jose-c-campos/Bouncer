//
//  Event.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Event: Identifiable, Codable, Hashable {
    @DocumentID var eventID: String?
    
    let ownerUid: String
    let name: String
    let dateTime: Date
    let address: String
    let price: Float
    let caption: String
    var imageURL: String?
    let timestamp: Timestamp
    var likes: Int
    
    // Assigns Firestore DocumentID as EventID
    var id: String {
        return eventID ?? NSUUID().uuidString
    }
    var user: User?
}
