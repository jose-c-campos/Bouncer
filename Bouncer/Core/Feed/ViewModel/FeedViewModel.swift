//
//  FeedViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var events = [Event]()
    
    init() {
        Task { try await fetchEvents() }
    }
    
    @MainActor
    func fetchEvents() async throws {
        self.events = try await EventService.fetchEvents()
        try await fetchUserDataForEvents()
    }
    
    // Loop through events only after we have fetched them, and update array accordingly
    private func fetchUserDataForEvents() async throws {
        for i in 0 ..< events.count {
            let event = events[i]
            let ownerUid = event.ownerUid
            let eventUser = try await UserService.fetchUser(withUid: ownerUid)
            events[i].user = eventUser
        }
    }
}
