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
            VStack(spacing: 0) {
                // Map Section
                Map(coordinateRegion: $region, annotationItems: groceryStores) { store in
                    MapAnnotation(coordinate: store.coordinate) {
                        VStack {
                            Image(systemName: "cart.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(8)
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                            
                            Text(store.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(4)
                                .shadow(radius: 2)
                        }
                    }
                }
                .frame(height: 350)
                
                // Store List Section
                List(groceryStores) { store in
                    HStack {
                        Image(systemName: "storefront.fill")
                            .foregroundColor(.orange)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("1.2 km away")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 2) {
                                ForEach(0..<5) { i in
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundColor(i < 4 ? .yellow : .gray.opacity(0.3))
                                }
                                Text("4.1")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button("Navigate") {
                            openInMaps(store: store)
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Grocery Stores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        refreshStores()
                    }
                    .foregroundColor(.orange)
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func openInMaps(store: GroceryStore) {
        print("🗺️ Opening navigation to \(store.name)")
        
        // Method 1: Apple Maps URL Scheme (Primary)
        let urlString = "http://maps.apple.com/?daddr=\(store.coordinate.latitude),\(store.coordinate.longitude)&dirflg=d&t=m"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url) { success in
                if success {
                    print("✅ Successfully opened Apple Maps")
                } else {
                    print("❌ Failed to open Apple Maps, trying MKMapItem")
                    openWithMKMapItem(store: store)
                }
            }
        } else {
            print("❌ Invalid URL, trying MKMapItem")
            openWithMKMapItem(store: store)
        }
    }
    
    private func openWithMKMapItem(store: GroceryStore) {
        let placemark = MKPlacemark(coordinate: store.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = store.name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapTypeKey: NSNumber(value: MKMapType.standard.rawValue)
        ])
        
        print("📍 Opened \(store.name) with MKMapItem")
    }
    
    private func refreshStores() {
        print("🔄 Refreshing store locations...")
        // You could implement real store data fetching here
        // For now, just update the region slightly to show refresh action
        withAnimation {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 38.4237, longitude: 27.1428),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
}

// MARK: - Supporting Models

struct GroceryStore: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            print("⚠️ Location permission not granted")
            return
        }
        
        manager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.userLocation = location
            print("📍 User location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            print("🔐 Location authorization status: \(status.rawValue)")
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("✅ Location permission granted")
                self.requestLocation()
            case .denied, .restricted:
                print("❌ Location permission denied")
            case .notDetermined:
                print("⏳ Location permission not determined")
            @unknown default:
                print("❓ Unknown location permission status")
            }
        }
    }
}

#Preview {
    GroceryFinderView()
}
