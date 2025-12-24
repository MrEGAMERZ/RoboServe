//
//  TableServiceFlow.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
// ==========================================
// File: Views/TableServiceFlow.swift
// ==========================================

import SwiftUI

struct TableServiceFlow: View {
    @Binding var selectedMode: ContentView.AppMode?
    @StateObject private var viewModel = OrderViewModel()
    
    var body: some View {
        Group {
            if viewModel.tableNumber.isEmpty {
                TableNumberView(viewModel: viewModel, selectedMode: $selectedMode)
            } else if viewModel.orderStatus == .confirmed {
                OrderConfirmationView(viewModel: viewModel)
            } else {
                MenuView(viewModel: viewModel, selectedMode: $selectedMode)
            }
        }
    }
}
