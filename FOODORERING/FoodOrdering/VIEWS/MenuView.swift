//
//  MenuView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Views/MenuView.swift
// ==========================================

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: OrderViewModel
    @Binding var selectedMode: ContentView.AppMode?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                MenuHeaderView(viewModel: viewModel, selectedMode: $selectedMode)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            MenuCategorySection(
                                category: category,
                                items: viewModel.menuItems.filter { $0.category == category },
                                onAddItem: { item in
                                    viewModel.addToCart(item)
                                }
                            )
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            if viewModel.showCart {
                CartView(viewModel: viewModel)
                    .transition(.move(edge: .trailing))
            }
            
            if viewModel.showPayment {
                PaymentView(viewModel: viewModel)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
