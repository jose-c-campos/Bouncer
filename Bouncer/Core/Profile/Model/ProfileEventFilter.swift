//
//  ProfileBouncerFilter.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import Foundation

// Creating this as a model makes it scalebale if we want to add more cases
enum ProfileEventFilter: Int, CaseIterable, Identifiable {
    case events
    case tickets
    
    var title: String {
        switch self {
        case .events: return "Events"
        case .tickets: return "Tickets"
        }
    }
    
    var id: Int {return self.rawValue}
}
