//
//  ViewController.swift
//  CurrentLocationPractice
//
//  Created by Taylor Frost on 7/11/16.
//  Copyright © 2016 Taylor Frost. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager!
    var pinName: String = ""
   
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManagerThings()
        
   }
    
    func locationManagerThings() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
    }

    @IBAction func buttonTapped(sender: UIBarButtonItem) {
        
        self.addPin(40.439324, longitude: -111.815627, titleString: "Frost Home", subtitleString: "Sunset Hills Drive")
        
        let latitude = 40.439324
        
        let longitude = -111.815627
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        self.centerMap(location)
        
        self.alertControllerCode()
       
    }
    
    func addPin(latitude: Double, longitude: Double, titleString: String, subtitleString: String) {
        
        // 2. Create a CLLocationCoordinate2D
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        // 3. Create an instance of MKPointAnnotation
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = titleString
        annotation.subtitle = subtitleString
        
        // 4. Add to the annotation to the mapView
        self.mapView.addAnnotation(annotation)
    }
    
    func centerMap(centerCoordinate: CLLocationCoordinate2D) {
        
        // 1. Create an CoordinateSpan
        let span = MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
        
        // 2. Create the Region
        
        let region = MKCoordinateRegion(
            center: centerCoordinate,
            span: span
        )
        
        // 3. Add
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func alertControllerCode() {
        
        let alertController = UIAlertController(title: "Add Pin", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let name = firstTextField.text {
                self.pinName = name
            }

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Pin Name"
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }

}

