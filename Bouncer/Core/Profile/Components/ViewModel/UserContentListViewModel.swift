//
//  UserContentListViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/10/24.
//

import Foundation

class UserContentListViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var tickets = [Ticket]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task {
            try await fetchUserEvents()
            try await fetchUserTickets()
        }
    }
    
    @MainActor
    func fetchUserEvents() async throws {
        var events = try await EventService.fetchUserEvents(uid: user.id)
        
        for i in 0 ..< events.count {
            events[i].user = self.user
        }
        self.events = events
    }
    
    @MainActor
    func fetchUserTickets() async throws {
        var tickets = try await TicketService.fetchUserTickets(uid: user.id)
        
        for i in 0 ..< tickets.count {
            tickets[i].user = self.user
        }
        self.tickets = tickets
    }
}
