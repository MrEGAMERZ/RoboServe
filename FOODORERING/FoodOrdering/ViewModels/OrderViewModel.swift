//
//  ViewModel.swift
//  FoodOrdering
//
//  Created by MAIN on 11/26/25.
//

// ==========================================
// File: ViewModels/OrderViewModel.swift
// ==========================================

import Foundation
import Combine

class OrderViewModel: ObservableObject {
    @Published var tableNumber: String = ""
    @Published var cart: [CartItem] = []
    @Published var orderStatus: OrderStatus = .ordering
    @Published var showCart: Bool = false
    @Published var showPayment: Bool = false


    let menuItems: [MenuItem] = [
        // Mains
        MenuItem(id: 1, name: "Margherita Pizza", price: 999, category: "Main", emoji: "🍕"),
        MenuItem(id: 2, name: "Chicken Burger", price: 350, category: "Main", emoji: "🍔"),
        MenuItem(id: 3, name: "Caesar Salad", price: 299, category: "Main", emoji: "🥗"),
        MenuItem(id: 4, name: "Pasta Carbonara", price: 499, category: "Main", emoji: "🍝"),
        MenuItem(id: 5, name: "Grilled Steak", price: 1599, category: "Main", emoji: "🥩"),
        
        // Sides
        MenuItem(id: 6, name: "French Fries", price: 200, category: "Sides", emoji: "🍟"),
        MenuItem(id: 7, name: "Onion Rings", price: 199, category: "Sides", emoji: "🧅"),
        MenuItem(id: 8, name: "Garlic Bread", price: 299, category: "Sides", emoji: "🥖"),
        
        // Drinks
        MenuItem(id: 9, name: "Coca Cola", price: 50, category: "Drinks", emoji: "🥤"),
        MenuItem(id: 10, name: "Lemonade", price: 60, category: "Drinks", emoji: "🍋"),
        MenuItem(id: 11, name: "Iced Tea", price: 120, category: "Drinks", emoji: "🧃"),
        MenuItem(id: 12, name: "Coffee", price: 60, category: "Drinks", emoji: "☕"),
        
        // Desserts
        MenuItem(id: 13, name: "Chocolate Cake", price: 1200, category: "Desserts", emoji: "🍰"),
        MenuItem(id: 14, name: "Ice Cream", price: 240, category: "Desserts", emoji: "🍨"),
        MenuItem(id: 15, name: "Apple Pie", price: 799, category: "Desserts", emoji: "🥧")
    ]
    
    var categories: [String] {
        Array(Set(menuItems.map { $0.category })).sorted()
    }
    
    var totalItems: Int {
        cart.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        cart.reduce(0) { $0 + ($1.menuItem.price * Double($1.quantity)) }
    }
    
    func addToCart(_ item: MenuItem) {
        if let index = cart.firstIndex(where: { $0.menuItem.id == item.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartItem(menuItem: item, quantity: 1))
        }
    }
    
    func updateQuantity(for cartItem: CartItem, delta: Int) {
        if let index = cart.firstIndex(where: { $0.id == cartItem.id }) {
            cart[index].quantity += delta
            if cart[index].quantity <= 0 {
                cart.remove(at: index)
            }
        }
    }
    
    func removeFromCart(_ cartItem: CartItem) {
        cart.removeAll { $0.id == cartItem.id }
    }
    
    func placeOrder() {
        orderStatus = .confirmed
        
        // Submit order to Firestore
        let order = Order(
            tableNumber: tableNumber,
            items: cart,
            totalPrice: totalPrice,
            timestamp: Date(),
            status: "pending"
        )
        
        FirestoreManager.shared.createOrder(order) { result in
            switch result {
            case .success(let orderId):
                print("Order created with ID: \(orderId)")
            case .failure(let error):
                print("Error creating order: \(error.localizedDescription)")
            }
        }
        
        // Reset after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.resetOrder()
        }
    }

    
    func resetOrder() {
        cart = []
        orderStatus = .ordering
        showCart = false
    }
    
    func resetAll() {
        tableNumber = ""
        cart = []
        orderStatus = .ordering
        showCart = false
    }
}

