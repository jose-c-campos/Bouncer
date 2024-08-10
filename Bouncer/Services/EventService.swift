//
//  EventService.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct EventService {
    static func uploadEvent(_ event: Event) async throws {
        guard let eventData = try? Firestore.Encoder().encode(event) else { return }
        try await Firestore.firestore().collection("events").addDocument(data: eventData)
    }
    
    // Fetch events for feed order by timestamp
    static func fetchEvents() async throws -> [Event] {
        let snapshot = try await Firestore
            .firestore()
            .collection("events")
            .order(by:"timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Event.self) })
    }
    
    // Get all events speciic to a user, and sort them by timestamp
    static func fetchUserEvents(uid: String) async throws -> [Event] {
        let snapshot = try await Firestore
            .firestore()
            .collection("events")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let events = snapshot.documents.compactMap({ try? $0.data(as: Event.self) })
        return events.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
