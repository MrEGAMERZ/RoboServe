//
//  MenuCategoryView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//


// ==========================================
// File: Views/Components/MenuCategorySection.swift
// ==========================================

import SwiftUI

struct MenuCategorySection: View {
    let category: String
    let items: [MenuItem]
    let onAddItem: (MenuItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(category)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(items) { item in
                        MenuItemCard(item: item, onAdd: {
                            onAddItem(item)
                        })
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
