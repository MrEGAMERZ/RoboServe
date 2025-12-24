//
//  CartView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Views/CartView.swift
// ==========================================

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showCart = false
                }
            
            HStack {
                Spacer()
                
                VStack(spacing: 0) {
                    CartHeaderView(viewModel: viewModel)
                    
                    if viewModel.cart.isEmpty {
                        EmptyCartView()
                    } else {
                        CartContentView(viewModel: viewModel)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                .shadow(radius: 10)
            }
        }
    }
}

