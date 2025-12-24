//
//  KitchenServiceView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

import Foundation

// ==========================================
// File: Views/KitchenServiceView.swift
// ==========================================

import SwiftUI

struct KitchenServiceView: View {
    @Binding var selectedMode: ContentView.AppMode?
    @StateObject private var viewModel = KitchenViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    viewModel.stopListening()
                    selectedMode = nil
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }
                
                Spacer()
                
                Text("🍳 Kitchen Orders")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(viewModel.orders.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(20)
                    .padding(.trailing)
            }
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
            .shadow(radius: 2)
            
            if viewModel.orders.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "tray")
                        .font(.system(size: 80))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("No Orders")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("Orders will appear here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.orders) { order in
                            KitchenOrderCard(order: order, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.startListening()
        }
        .onDisappear {
            viewModel.stopListening()
        }
    }
}

struct KitchenOrderCard: View {
    let order: Order
    @ObservedObject var viewModel: KitchenViewModel
    
    var statusColor: Color {
        switch order.status {
        case "pending": return .orange
        case "preparing": return .blue
        case "ready": return .green
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Table \(order.tableNumber)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(order.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(order.status.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .cornerRadius(8)
            }
            
            Divider()
            
            // Items
            VStack(alignment: .leading, spacing: 10) {
                ForEach(order.items) { item in
                    HStack {
                        Text("\(item.quantity)x")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(width: 40)
                        
                        Text(item.menuItem.name)
                            .font(.body)
                        
                        Spacer()
                        
                        Text("$\(Double(item.quantity) * item.menuItem.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Total:")
                    .font(.headline)
                
                Spacer()
                
                Text("$\(order.totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            // Action Buttons
            HStack(spacing: 10) {
                if order.status == "pending" {
                    Button(action: {
                        viewModel.updateOrderStatus(orderId: order.id!, status: "preparing")
                    }) {
                        Text("Start Preparing")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else if order.status == "preparing" {
                    Button(action: {
                        viewModel.updateOrderStatus(orderId: order.id!, status: "ready")
                    }) {
                        Text("Mark Ready")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                } else if order.status == "ready" {
                    Button(action: {
                        viewModel.deleteOrder(orderId: order.id!)
                    }) {
                        Text("Mark Served")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

