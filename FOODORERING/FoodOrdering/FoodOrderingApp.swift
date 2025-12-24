// ==========================================
// File: RestaurantOrderApp.swift
// ==========================================

import SwiftUI
import FirebaseCore

@main
struct RestaurantOrderApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

