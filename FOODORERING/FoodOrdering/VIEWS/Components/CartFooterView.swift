//
//  CartFooterView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//


// ==========================================
// File: Views/Components/CartFooterView.swift
// ==========================================

import SwiftUI

struct CartFooterView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Divider()
            
            HStack {
                Text("Total:")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("₹\(Int(viewModel.totalPrice))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal)
            
            Button(action: {
                viewModel.showCart = false
                viewModel.showPayment = true
            }) {
                Text("Proceed to Payment")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(UIColor.systemBackground))
    }
}
