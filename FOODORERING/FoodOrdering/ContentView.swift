
// ==========================================
// File: Views/ContentView.swift
// ==========================================

import SwiftUI

struct ContentView: View {
    @State private var selectedMode: AppMode? = nil
    
    enum AppMode {
        case kitchen
        case table
        case games
    }
    
    var body: some View {
        Group {
            if selectedMode == nil {
                MainMenuView(selectedMode: $selectedMode)
            } else if selectedMode == .kitchen {
                KitchenServiceView(selectedMode: $selectedMode)
            } else if selectedMode == .table {
                TableServiceFlow(selectedMode: $selectedMode)
            } else if selectedMode == .games {
                GamesView(selectedMode: $selectedMode)
            }
        }
    }
}
