//
//  KitchenViewModel.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//


// ==========================================
// File: ViewModels/KitchenViewModel.swift
// ==========================================

import Foundation
import FirebaseFirestore
import Combine

class KitchenViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading: Bool = false
    
    private var listener: ListenerRegistration?
    
    func startListening() {
        listener = FirestoreManager.shared.listenToOrders { [weak self] result in
            switch result {
            case .success(let orders):
                DispatchQueue.main.async {
                    self?.orders = orders.sorted { $0.timestamp > $1.timestamp }
                }
            case .failure(let error):
                print("Error listening to orders: \(error.localizedDescription)")
            }
        }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func updateOrderStatus(orderId: String, status: String) {
        FirestoreManager.shared.updateOrderStatus(orderId: orderId, status: status) { result in
            switch result {
            case .success():
                print("Order status updated to: \(status)")
            case .failure(let error):
                print("Error updating order: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteOrder(orderId: String) {
        FirestoreManager.shared.deleteOrder(orderId: orderId) { result in
            switch result {
            case .success():
                print("Order deleted successfully")
            case .failure(let error):
                print("Error deleting order: \(error.localizedDescription)")
            }
        }
    }
}

