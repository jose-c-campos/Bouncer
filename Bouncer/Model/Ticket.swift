//
//  Ticket.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Ticket: Identifiable, Codable, Hashable {
    @DocumentID var ticketID: String?
    
    let eventId: String
    let eventOwnerUid: String
    let ticketOwnerUid: String
    let eventName: String
    let price: Float
    let dateTime: Date
    let address: String
    var qrCodeURL: String
    let timestamp: Timestamp
    var valid: Bool
    
    // Assigns Firestore DocumentID as TicketID
    var id: String {
        return ticketID ?? NSUUID().uuidString
    }
    var user: User?
}
