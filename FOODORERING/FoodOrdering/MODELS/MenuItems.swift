//
//  MenuItems.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Models/MenuItem.swift
// ==========================================

import Foundation

struct MenuItem: Identifiable, Codable {
    let id: Int
    let name: String
    let price: Double
    let category: String
    let emoji: String
}
