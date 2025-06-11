//
//  SharedModels.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 10.06.2025.
//


import Foundation
import MapKit

// MARK: - Maps Models
struct GroceryStoreModel: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double  // Add this
    let rating: Double    // Add this
    let phone: String     // Add this
    let hours: String     // Add this
}

struct RestaurantModel: Identifiable {
    let id = UUID()
    let name: String
    let cuisine: String
    let rating: Double
}
