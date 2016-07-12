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
    var currentLat : Double = 0
    var currentLong : Double = 0
    var currentLocationName : String = ""
   
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManagerThings()
        self.loadValues()
        
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
        
        self.currentLat = newLocation.coordinate.latitude
        self.currentLong = newLocation.coordinate.longitude
        
    }

    @IBAction func buttonTapped(sender: UIBarButtonItem) {
        
        self.addPin(self.currentLat, longitude: self.currentLong, titleString: self.currentLocationName)
        
        self.alertControllerCode()
       
    }
    
    func addPin(latitude: Double, longitude: Double, titleString: String) {
        
        // 2. Create a CLLocationCoordinate2D
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        // 3. Create an instance of MKPointAnnotation
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = titleString
        
        // 4. Add to the annotation to the mapView
        self.mapView.addAnnotation(annotation)
        
        self.centerMap(location)
        
        self.saveDefaults()

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
                
                self.currentLocationName = name
                
                self.saveDefaults()
    
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
            self.addPin(self.currentLat, longitude: self.currentLong, titleString: self.currentLocationName)
                
            })

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
    
    func saveDefaults() {
        
        NSUserDefaults.standardUserDefaults().setDouble(self.currentLat, forKey: kSelected_Latitude)
        NSUserDefaults.standardUserDefaults().setDouble(self.currentLong, forKey: kSelected_Longitude)
        NSUserDefaults.standardUserDefaults().setObject(self.currentLocationName, forKey: kSelected_TitleString)
    }
    
    func loadValues() {
        self.currentLat = NSUserDefaults.standardUserDefaults().doubleForKey(kSelected_Latitude)
        
        self.currentLong = NSUserDefaults.standardUserDefaults().doubleForKey(kSelected_Longitude)
        
        if let name = NSUserDefaults.standardUserDefaults().objectForKey(kSelected_TitleString) as? String {
            
            self.currentLocationName = name
            
            self.addPin(self.currentLat, longitude: self.currentLong, titleString: self.currentLocationName)
            
            
        }
            
        
        
    }
    
    

}

