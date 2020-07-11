//
//  RouteDrawer.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/11/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import MapKit

final class RouteDrawer {
    
    static func addLastRunToMap(mapView: MKMapView, run: Run) -> MKPolyline? {
        guard let lastRunLocations = run.locations as? Set<Location> else {
            return nil
        }
        
        let sortedCoordinates = lastRunLocations.sorted { (locationA, locationB) -> Bool in
            guard let locationATimestamp = locationA.timestamp,
                let locationBTimestamp = locationB.timestamp else { return false }
            return locationATimestamp > locationBTimestamp
        }
        
        let coordinates = sortedCoordinates.map { (location) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
                
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPrevRoute(locations: Array(lastRunLocations)),
                          animated: true)

        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    private static func centerMapOnPrevRoute(locations: [Location]) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else { return MKCoordinateRegion() }
        var minLat = initialLocation.latitude
        var minLng = initialLocation.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                                                 longitude: (minLng + maxLng) / 2),
                                  span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4,
                                                         longitudeDelta: (maxLng - minLng) * 1.4 ))
    }
}
