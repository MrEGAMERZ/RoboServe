//
//  OrderonfirmationView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

import Foundation

// ==========================================
// File: Views/OrderConfirmationView.swift
// ==========================================

import SwiftUI

struct OrderConfirmationView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.green.opacity(0.3), Color.mint.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.green)
                
                Text("Order Placed!")
                    .font(.system(size: 42, weight: .bold))
                
                VStack(spacing: 10) {
                    Text("🤖 Robot is delivering to")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("Table \(viewModel.tableNumber)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
        }
    }
}

