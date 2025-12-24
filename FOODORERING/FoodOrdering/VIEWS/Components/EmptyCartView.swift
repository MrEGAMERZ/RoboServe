//
//  EmptyCartView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Views/Components/EmptyCartView.swift
// ==========================================

import SwiftUI

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.3))
            
            Text("Cart is empty")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxHeight: .infinity)
    }
}
