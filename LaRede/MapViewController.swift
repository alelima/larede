//
//  MapViewController.swift
//  LaRede
//
//  Created by Alessandro on 16/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView! {
        didSet {
            let logPressAction = #selector(MapViewController.longPress(recognizer:))
            let longPress = UILongPressGestureRecognizer(target: self, action: logPressAction)
            mapView.addGestureRecognizer(longPress)
        }
    }
    
    var mapAddressCoordinate: CLLocationCoordinate2D?
    
    
    
    @objc func longPress(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed: fallthrough
        case .ended:
            let point = recognizer.location(in: mapView)
            mapAddressCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapAddressCoordinate!
            mapView.addAnnotation(annotation)           
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBasicLocationServices()
        // Do any additional setup after loading the view.
    }

    let locationManager = CLLocationManager()
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
           // disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            //enableMyWhenInUseFeatures()
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { (location) in
            print(location.coordinate.latitude)
            let mapCam = MKMapCamera(lookingAtCenter: location.coordinate, fromEyeCoordinate: location.coordinate, eyeAltitude: location.altitude)
            mapView.setCamera(mapCam, animated: true)
        }
    }
    
}
