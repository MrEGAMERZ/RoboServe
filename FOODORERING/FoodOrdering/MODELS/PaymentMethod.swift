//
//  PaymentMethod.swift
//  FoodOrdering
//
//  Created by MAIN on 12/21/25.
// ==========================================
// File: Models/PaymentMethod.swift
// ==========================================

import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case upi = "UPI"
    case card = "Card"
    case cash = "Cash"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .upi: return "indianrupeesign.circle.fill"
        case .card: return "creditcard.fill"
        case .cash: return "banknote.fill"
        }
    }
    
    var color: String {
        switch self {
        case .upi: return "purple"
        case .card: return "blue"
        case .cash: return "green"
        }
    }
}

struct PaymentStatus {
    var isProcessing: Bool = false
    var isSuccess: Bool = false
    var isFailed: Bool = false
}
