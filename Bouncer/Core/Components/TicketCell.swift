//
//  TicketCell.swift
//  Bouncer
//
//  Created by Jose Campos on 8/12/24.
//

import Foundation


import SwiftUI

struct TicketCell: View {
    let ticket: Ticket
    @State private var isActive: Bool = false
    
    
    var body: some View {
        NavigationLink(destination: TicketView(ticket: ticket)) {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    CircularProfileImageView(user: ticket.user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(ticket.user?.username ?? "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(ticket.timestamp.timeStampString())
                                .font(.caption)
                                .foregroundColor(Color(.systemGray3))
                            
                            Button {
                                
                            } label : {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color(.darkGray))
                            }
                        }
                        
                        Text(ticket.eventName)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                        
                        // Event date display
                        Text(ticket.dateTime.formatted(.dateTime.month().day().hour().minute()))
                            .font(.footnote)
                            .foregroundColor(Color(.black))

                        // Event address display
                        Text(ticket.address)
                            .font(.footnote)
                            .foregroundColor(Color(.black))
                    }
                }
                Divider()
            }
            .padding()
            
        }
    }
}


struct TicketCell_Previews: PreviewProvider {
    static var previews: some View {
        TicketCell(ticket: dev.ticket)
    }
}
