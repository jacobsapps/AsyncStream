//
//  LocationManager.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private var rotationCallback: ((Double) -> Void)?
    
    var rotationAngleStream: AsyncStream<Double> {
        AsyncStream { continuation in
            Task {
                rotationCallback = {
                    continuation.yield($0)
                }
            }
            continuation.onTermination = { [weak self] _ in 
                self?.stop()
            }
        }
    }
    
    override private init() {
        super.init()
        requestWhenInUseAuthorization()
        delegate = self
    }
    
    func start() {
        startUpdatingHeading()
    }
    
    func stop() {
        stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        rotationCallback?(-newHeading.magneticHeading)
    }
}
