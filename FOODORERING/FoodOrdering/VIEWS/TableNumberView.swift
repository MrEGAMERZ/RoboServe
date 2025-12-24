// File: Views/TableNumberView.swift

import SwiftUI

struct TableNumberView: View {
    @ObservedObject var viewModel: OrderViewModel
    @Binding var selectedMode: ContentView.AppMode?
    
    let tables = ["1", "2", "3", "4"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.indigo.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
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
                }
                
                Spacer()
                
                VStack(spacing: 40) {
                    // Title Section
                    VStack(spacing: 15) {
                        Text("🤖")
                            .font(.system(size: 80))
                        
                        Text("Select Your Table")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Choose a table to start ordering")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Table Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(tables, id: \.self) { table in
                            TableButton(
                                tableNumber: table,
                                isAvailable: true
                            ) {
                                viewModel.tableNumber = table
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
    }
}

struct TableButton: View {
    let tableNumber: String
    let isAvailable: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // Table Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isAvailable ? [Color.blue, Color.blue.opacity(0.7)] : [Color.gray, Color.gray.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(radius: 5)
                    
                    VStack(spacing: 5) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        
                        Text(tableNumber)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Table Label
                Text("Table \(tableNumber)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Status
                Text(isAvailable ? "Available" : "Occupied")
                    .font(.caption)
                    .foregroundColor(isAvailable ? .green : .red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(isAvailable ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 3)
        }
        .disabled(!isAvailable)
    }
}

// Preview
#Preview {
    TableNumberView(
        viewModel: OrderViewModel(),
        selectedMode: .constant(.table)
    )
}

#Preview("Single Table Button") {
    TableButton(
        tableNumber: "1",
        isAvailable: true
    ) {
        print("Table 1 selected")
    }
    .padding()
}
