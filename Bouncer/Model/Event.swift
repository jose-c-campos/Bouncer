//
//  Event.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var eventID: String?
    
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    
    // Assigns Firestore DocumentID as EventID
    var id: String {
        return eventID ?? NSUUID().uuidString
    }
    var user: User?
}
