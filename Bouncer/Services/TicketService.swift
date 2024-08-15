//
//  TicketService.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct TicketService {
    static func uploadTicket(_ ticket: Ticket) async throws {
        guard let ticketData = try? Firestore.Encoder().encode(ticket) else { return }
        try await Firestore.firestore().collection("tickets").addDocument(data: ticketData)
    }
    
    // Fetch events for feed order by timestamp
    static func fetchTickets() async throws -> [Ticket] {
        let snapshot = try await Firestore
            .firestore()
            .collection("tickets")
            .order(by:"timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Ticket.self) })
    }
    
    // Get all events speciic to a user, and sort them by timestamp
    static func fetchUserTickets(uid: String) async throws -> [Ticket] {
        let snapshot = try await Firestore
            .firestore()
            .collection("tickets")
            .whereField("ticketOwnerUid", isEqualTo: uid)
            .getDocuments()
        
        let tickets = snapshot.documents.compactMap({ try? $0.data(as: Ticket.self) })
        return tickets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
