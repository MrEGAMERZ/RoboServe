//
//  CartHeaderView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//


// ==========================================
// File: Views/Components/CartHeaderView.swift
// ==========================================

import SwiftUI

struct CartHeaderView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        HStack {
            Text("Your Cart")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                viewModel.showCart = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}
