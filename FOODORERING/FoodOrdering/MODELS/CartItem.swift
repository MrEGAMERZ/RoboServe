//
//  CartItem.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//
// ==========================================
// File: Models/CartItem.swift
// ==========================================

import Foundation

struct CartItem: Identifiable, Codable {
    let id: String
    let menuItem: MenuItem
    var quantity: Int
    
    init(id: String = UUID().uuidString, menuItem: MenuItem, quantity: Int) {
        self.id = id
        self.menuItem = menuItem
        self.quantity = quantity
    }
}
