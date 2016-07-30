//
//  ViewController.swift
//  BinThere
//
//  Created by Daniel Richardson on 30/07/2016.
//  Copyright © 2016 Daniel Richardson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var location_infomation: UILabel!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var Longitude: UITextField!
    
    var coreLocationManger = CLLocationManager()
    var locationManager:LocationManager!
    
    
    @IBAction func updateMapView(sender: UIButton) {
        getLocation()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManger.delegate = self;
        locationManager = LocationManager.sharedInstance
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManger.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization)) || coreLocationManger.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) {
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil {
                coreLocationManger.requestAlwaysAuthorization()
            } else {
                print("No description provided")
            }
        } else {
            getLocation()
        }
    }

    func getLocation() {
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> Void in
            self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
            print(error)
            print(latitude, longitude)
        }
    }


    func displayLocation(location:CLLocation) {
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            print(reverseGecodeInfo)
            let address = reverseGecodeInfo?.objectForKey("formattedAddress") as! String
            self.location_infomation.text = address
        })
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted {
            self.getLocation()
        }
    }
    


}

