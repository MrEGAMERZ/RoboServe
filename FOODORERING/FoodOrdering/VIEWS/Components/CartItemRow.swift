//
//  CartItemView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//



// ==========================================
// File: Views/Components/CartItemRow.swift
// ==========================================

import SwiftUI

struct CartItemRow: View {
    let cartItem: CartItem
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(cartItem.menuItem.name)
                    .font(.headline)
                
                Text("₹\(cartItem.menuItem.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing: 10) {
                    Button(action: {
                        viewModel.updateQuantity(for: cartItem, delta: -1)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 30)
                    
                    Button(action: {
                        viewModel.updateQuantity(for: cartItem, delta: 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
                
                Text("₹\(Double(cartItem.quantity) * cartItem.menuItem.price, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}
