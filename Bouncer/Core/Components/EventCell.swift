//
//  InviteCell.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI

struct EventCell: View {
    let event: Event
    @State private var isActive: Bool = false
    
    
    var body: some View {
        NavigationLink(destination: CheckoutView(event: event)) {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    CircularProfileImageView(user: event.user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(event.user?.username ?? "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(event.timestamp.timeStampString())
                                .font(.caption)
                                .foregroundColor(Color(.systemGray3))
                            
                            Button {
                                
                            } label : {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color(.darkGray))
                            }
                        }
                        
                        Text(event.name)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                        
                        
                        // Event Image Display
                        if let imageUrl = event.imageURL, let url = URL(string: imageUrl) {
                            GeometryReader { geometry in
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width)
                                        .clipped() // Ensure the image doesn't overflow
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: geometry.size.width, height: geometry.size.width * 0.6)
                                }
                            }
                            .frame(height: 250) // Set a fixed height for the image
                            .cornerRadius(10)
                            .padding(.top, 8)
                        }
                        // Event price display
                        Text("Presale: $\(event.price, specifier: "%.2f")")
                            .font(.footnote)
                            .foregroundColor(Color(.black))
                        
                        // Event date display
                        Text(event.dateTime.formatted(.dateTime.month().day().hour().minute()))
                            .font(.footnote)
                            .foregroundColor(Color(.black))

                        // Event address display
                        Text(event.address)
                            .font(.footnote)
                            .foregroundColor(Color(.black))
                        
                        // Only display the caption if it's non-empty
                        if !event.caption.isEmpty {
                            Text(event.caption)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                
                            } label: {
                                Image(systemName: "heart")
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "bubble.right")
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "arrow.rectanglepath")
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "paperplane")
                            }
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                    }
                }
                Divider()
            }
            .padding()
            
        }
    }
}

struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        EventCell(event: dev.event)
    }
}
