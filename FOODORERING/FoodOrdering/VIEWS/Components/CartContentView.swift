//
//  CartContentView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
// ==========================================
// File: Views/Components/CartContentView.swift
// ==========================================

import SwiftUI

struct CartContentView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.cart) { cartItem in
                        CartItemRow(cartItem: cartItem, viewModel: viewModel)
                    }
                }
                .padding()
            }
            
            CartFooterView(viewModel: viewModel)
        }
    }
}
