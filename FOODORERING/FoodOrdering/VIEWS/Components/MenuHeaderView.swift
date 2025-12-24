//
//  MenuHeaderView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Views/Components/MenuHeaderView.swift
// ==========================================

import SwiftUI

struct MenuHeaderView: View {
    @ObservedObject var viewModel: OrderViewModel
    @Binding var selectedMode: ContentView.AppMode?
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.resetAll()
                selectedMode = nil
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("RoboServe Menu")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("🤖 Table \(viewModel.tableNumber)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Button(action: {
                viewModel.showCart = true
            }) {
                ZStack(alignment: .topTrailing) {
                    HStack {
                        Image(systemName: "cart.fill")
                        Text("Cart")
                        Text("(\(viewModel.totalItems))")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(.orange)
                    .cornerRadius(10)
                    
                    if viewModel.cart.count > 0 {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(viewModel.cart.count)")
                                    .foregroundColor(.white)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            )
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.orange, Color.red],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}
