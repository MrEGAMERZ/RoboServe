//
//  TableServiceFlow.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.

// ==========================================
// File: Views/MainMenuView.swift
// ==========================================

import SwiftUI

struct MainMenuView: View {
    @Binding var selectedMode: ContentView.AppMode?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.orange.opacity(0.2), Color.red.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Text("RoboServe")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.primary)
                    
                    
                    Text("Restaurant Management App")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    if let appIcon = UIImage(named: "AppIcon") ??
                                                         UIImage(named: "AppIcon60x60") {
                                            Image(uiImage: appIcon)
                                                .resizable()
                                                .frame(width: 120, height: 120)
                                                .cornerRadius(26)
                                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                        } else {
                                            // Fallback if app icon not found
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 26)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [Color.orange, Color.red],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 120, height: 120)
                                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                                
                                                Text("🤖")
                                                    .font(.system(size: 70))
                                            }
                                        }
                    
                }
                .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 20) {
                    MenuButton(
                        icon: "fork.knife",
                        title: "Kitchen Service",
                        subtitle: "View & manage orders",
                        color: .blue
                    ) {
                        selectedMode = .kitchen
                    }
                    
                    MenuButton(
                        icon: "person.2.fill",
                        title: "Table Service",
                        subtitle: "Place customer orders",
                        color: .orange
                    ) {
                        selectedMode = .table
                    }
                    
                    MenuButton(
                        icon: "gamecontroller.fill",
                        title: "Games",
                        subtitle: "Fun activities for kids",
                        color: .purple
                    ) {
                        selectedMode = .games
                    }
                }
                .padding(.horizontal, 10,)
                
                
                Spacer()
            }
        }
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(color)
                    .frame(width: 70)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .padding(25)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}
#Preview {
    MainMenuView(selectedMode: .constant(nil))
}
