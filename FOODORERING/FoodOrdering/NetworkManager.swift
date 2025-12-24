//
//  NetworkManager.swift
//  FoodOrdering
//
//  Created by MAIN on 11/26/25.
//

// ==========================================
// File: Managers/NetworkManager.swift
// ==========================================

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // Example API endpoint
    private let baseURL = "https://your-api.com/api"
    
    func submitOrder(tableNumber: String, items: [CartItem], completion: @escaping (Result<String, Error>) -> Void) {
        // Create order payload
        let orderData: [String: Any] = [
            "tableNumber": tableNumber,
            "items": items.map { item in
                [
                    "menuItemId": item.menuItem.id,
                    "name": item.menuItem.name,
                    "quantity": item.quantity,
                    "price": item.menuItem.price
                ]
            },
            "totalPrice": items.reduce(0) { $0 + ($1.menuItem.price * Double($1.quantity)) },
            "timestamp": Date().timeIntervalSince1970
        ]
        
        // Convert to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: orderData) else {
            completion(.failure(NSError(domain: "Invalid data", code: -1)))
            return
        }
        
        // Create URL request
        guard let url = URL(string: "\(baseURL)/orders") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                completion(.success("Order submitted successfully"))
            } else {
                completion(.failure(NSError(domain: "Server error", code: -1)))
            }
        }.resume()
    }
    
    func fetchMenu(completion: @escaping (Result<[MenuItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/menu") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                let items = try JSONDecoder().decode([MenuItem].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
