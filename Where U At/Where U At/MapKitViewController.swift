//
//  MapKitViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/22/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/**
 A view controller to handle the map kit
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class MapKitViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapKitView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapKitView.showsUserLocation = true
        
    }
    
    func setLocation(latitude: String, longitude: String){
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        //let lat = "47.14"
        //let lon = "-122.44"
        
        //let center = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapKitView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }

}
