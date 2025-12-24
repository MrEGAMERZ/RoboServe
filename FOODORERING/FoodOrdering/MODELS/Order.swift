//
//  Order.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//
// ==========================================
// File: Models/Order.swift
// ==========================================

import Foundation
import FirebaseFirestore

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    let tableNumber: String
    let items: [CartItem]
    let totalPrice: Double
    let timestamp: Date
    var status: String // "pending", "preparing", "ready", "served"
    
    enum CodingKeys: String, CodingKey {
        case id
        case tableNumber
        case items
        case totalPrice
        case timestamp
        case status
    }
}
