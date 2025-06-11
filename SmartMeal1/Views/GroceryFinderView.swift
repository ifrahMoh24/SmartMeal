import SwiftUI
import MapKit
import CoreLocation

struct GroceryFinderView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.4237, longitude: 27.1428), // İzmir
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    let groceryStores = [
        GroceryStore(name: "Migros", coordinate: CLLocationCoordinate2D(latitude: 38.4237, longitude: 27.1428)),
        GroceryStore(name: "CarrefourSA", coordinate: CLLocationCoordinate2D(latitude: 38.4197, longitude: 27.1387)),
        GroceryStore(name: "A101", coordinate: CLLocationCoordinate2D(latitude: 38.4277, longitude: 27.1468)),
        GroceryStore(name: "BİM", coordinate: CLLocationCoordinate2D(latitude: 38.4157, longitude: 27.1347))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, annotationItems: groceryStores) { store in
                    MapAnnotation(coordinate: store.coordinate) {
                        VStack {
                            Image(systemName: "cart.fill")
                                .foregroundColor(.orange)
                                .font(.title2)
                                .background(Circle().fill(Color.white))
                            Text(store.name)
                                .font(.caption)
                                .background(Color.white.opacity(0.8))
                        }
                    }
                }
                .frame(height: 400)
                
                List(groceryStores) { store in
                    HStack {
                        Image(systemName: "cart")
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading) {
                            Text(store.name)
                                .font(.headline)
                            Text("1.2 km away")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Navigate") {
                            // Navigation action
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Grocery Stores")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        // Refresh action
                    }
                }
            }
        }
    }
}


struct GroceryStore: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
}
