//
//  PreviewProvider.swift
//  Bouncer
//
//  Created by Jose Campos on 8/9/24.
//

import Foundation
import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user = User(
        id: NSUUID().uuidString,
        fullname: "Max Verstappen",
        email: "max@gmail.com",
        username: "maxverstappen1"
    )
    
    let event = Event(
        ownerUid: "123",
        name: "Monster Mash",
        dateTime: Date(timeIntervalSince1970: 172800),
        address: "1 Vanderbilt Avenue NY, NY 10017",
        price: 5.0,
        caption: "Test Event",
        timestamp: Timestamp(),
        likes: 1
    )
    
    let ticket = Ticket(
        eventId: "CBNMkerkykk4YvuRosvq",
        eventOwnerUid: "bECciSwOYXXtY9gmQ0pgHSn8uLl2",
        ticketOwnerUid: "uy6f3lIyv8On93KNpIXnFOcW84t2",
        eventName: "Checo's Test Party",
        price: 10,
        dateTime: Date(timeIntervalSince1970: 172800),
        address: "TBD",
        qrCodeURL: "https://firebasestorage.googleapis.com:443/v0/b/bouncer-cacba.appspot.com/o/ticket_QR_Code_images%2F5B360EEB-C4E7-43AC-A37F-75F760AE9E80?alt=media&token=4ed3e098-439f-426d-b28e-07a46a86cd07",
        timestamp: Timestamp(),
        valid: true
    )
}
