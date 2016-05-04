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
    
    var userLatitude: String!
    var userLongitude: String!
    var username: String!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("loading view")
        print("lat to display: " + userLatitude)
        print("lon to display: " + userLongitude)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.startUpdatingLocation()
        
        setLocation()
        
        self.mapKitView.showsUserLocation = true
    }
    
    func setLocation(){
        print("setLocation called")
        print("setting center")
        print("lat to use: " + userLatitude)
        print("lon to use: " + userLongitude)
        let center = CLLocationCoordinate2D(latitude: Double(userLatitude)!, longitude: Double(userLongitude)!)
        
        print("creating center with a lat of " + userLatitude + " and a lon of " + userLongitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapKitView.setRegion(region, animated: true)
        
        let userPin = MKPointAnnotation()
        userPin.coordinate = center
        userPin.title = username
        userPin.subtitle = "Where he/she at"
        mapKitView.addAnnotation(userPin)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delegate Methods
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let location = locations.last
//        
//        //let lat = "47.14"
//        //let lon = "-122.44"
//        
//        //let center = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
//        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//        
//        self.mapKitView.setRegion(region, animated: true)
//        
//        self.locationManager.stopUpdatingLocation()
//    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }

}
