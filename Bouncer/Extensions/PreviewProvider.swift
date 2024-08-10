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
        caption: "Test Event",
        timestamp: Timestamp(),
        likes: 1
    )
}
