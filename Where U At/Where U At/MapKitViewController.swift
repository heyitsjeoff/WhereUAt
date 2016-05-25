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
 A view controller to handle the map kit and display user location
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class MapKitViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Properties
    @IBOutlet weak var mapKitView: MKMapView!
    
    var userLatitude: String!
    var userLongitude: String!
    var myLatitude: String!
    var myLongitude: String!
    var username: String!
    
    let locationManager = CLLocationManager()
    
    /**
     Called after the controller's view is loaded into memory.
     Performs locationManager initialization
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.mapKitView.showsUserLocation = true
    }
    
    /**
     Notifies the view controller that its view is about to be added to a view hierarchy and
     tries to sets friend location
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - animated: If true, the view is being added to the window using an animation.
     
     - version:
     1.0
     */
    override func viewWillAppear(animated: Bool) {
        setLocation()
    }
    
    /**
     Places a pin on the map to show the location of the friend
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    func setLocation(){
        if(userLatitude != nil && userLongitude != nil){
            //creates a center for the pin of the friend
            let center = CLLocationCoordinate2D(latitude: Double(userLatitude)!, longitude: Double(userLongitude)!)
            //sets a region for the view to be zoomed in on
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
            self.mapKitView.setRegion(region, animated: true)
            
            //create and set pin
            let userPin = MKPointAnnotation()
            userPin.coordinate = center
            userPin.title = username
            userPin.subtitle = "Where he/she at"
            mapKitView.addAnnotation(userPin)
        }
        else{
            if(myLatitude != nil && myLongitude != nil){
                //creates a center for where the user is at
                let center = CLLocationCoordinate2D(latitude: Double(myLatitude)!, longitude: Double(myLongitude)!)
                //sets a region for the view to be zoomed in on
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
                self.mapKitView.setRegion(region, animated: true)
            }
        }
    }
    
    /**
     Tells the delegate that the location manager was unable to retrieve a location value.
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - manager: The location manager object that was unable to retrieve the location.
        - error: The error object containing the reason the location or heading could not be retrieved.
     
     - version:
     1.0
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }

}
