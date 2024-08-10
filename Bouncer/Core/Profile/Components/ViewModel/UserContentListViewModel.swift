//
//  UserContentListViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation

class UserContentListViewModel: ObservableObject {
    @Published var events = [Event]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserEvents() }
    }
    
    @MainActor
    func fetchUserEvents() async throws {
        var events = try await EventService.fetchUserEvents(uid: user.id)
        
        for i in 0 ..< events.count {
            events[i].user = self.user
        }
        self.events = events
    }
}
