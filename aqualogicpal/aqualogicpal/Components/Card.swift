//
//  Card.swift
//  aqualogicpal
//
//  Created by Bryce Callender on 8/19/23.
//

import SwiftUI

struct Card<Content: View>: View {
    let content: Content
        
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.cardBackground)
                .shadow(radius: 10)
            
            self.content
        }
    }
}

#Preview {
    Card() {
        Text("I am in the card")
    }
}
