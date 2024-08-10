//
//  BouncerTextFieldModifier.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI

struct BouncerTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
