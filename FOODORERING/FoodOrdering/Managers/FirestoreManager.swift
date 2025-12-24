//
//  FirestoreManager.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Managers/FirestoreManager.swift
// ==========================================

import Foundation
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    private let ordersCollection = "orders"
    
    private init() {}
    
    // Create new order
    func createOrder(_ order: Order, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let ref = try db.collection(ordersCollection).addDocument(from: order)
            completion(.success(ref.documentID))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Listen to all active orders
    func listenToOrders(completion: @escaping (Result<[Order], Error>) -> Void) -> ListenerRegistration {
        return db.collection(ordersCollection)
            .whereField("status", in: ["pending", "preparing", "ready"])
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let orders = documents.compactMap { doc -> Order? in
                    try? doc.data(as: Order.self)
                }
                
                completion(.success(orders))
            }
    }
    
    // Update order status
    func updateOrderStatus(orderId: String, status: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(ordersCollection).document(orderId).updateData([
            "status": status
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Delete order (when served)
    func deleteOrder(orderId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(ordersCollection).document(orderId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

