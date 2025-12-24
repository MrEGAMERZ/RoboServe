//
//  MenuItemCard.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
// ==========================================
// File: Views/Components/MenuItemCard.swift (UPDATE)
// ==========================================

import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem
    let onAdd: () -> Void
    
    // Convert menu item name to image asset name
    var imageAssetName: String {
        item.name.replacingOccurrences(of: " ", with: "_")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Try to load image, fallback to emoji
            if let _ = UIImage(named: imageAssetName) {
                Image(imageAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 120)
                    .clipped()
                    .cornerRadius(10)
            } else {
                // Fallback to emoji if image not found
                Text(item.emoji)
                    .font(.system(size: 60))
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top)
                
                Text("₹\(Int(item.price))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            Button(action: onAdd) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.orange)
                .cornerRadius(8)
            }
        }
        .frame(width: 160)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}
