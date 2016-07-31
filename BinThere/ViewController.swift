//
//  ViewController.swift
//  BinThere
//
//  Created by Daniel Richardson on 30/07/2016.
//  Copyright © 2016 Daniel Richardson. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var coreLocationManger = CLLocationManager()
    var locationManager:LocationManager!
    
    var dataManager = DataManager()
    
    @IBAction func updateMapView(sender: UIButton) {
        getLocation()
    }
    
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        mapView.delegate = self
        
        coreLocationManger.delegate = self;
        self.mapView.delegate = self
        
        coreLocationManger.delegate = self
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
        }
    }
    
    func displayLocation(location:CLLocation) {
        
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        //let binList = dataManager.getClosestBins(location)
        let binList = dataManager.getBins(location, within: 2000.00)
        //let annotation = MKPointAnnotation()
        
        for bin in binList
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = bin.location.coordinate
            annotation.title = String(bin.type)
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
        
        mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        //let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
        //let annotation = MKPointAnnotation()
        //annotation.coordinate = locationPinCoord
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        //mapView.addAnnotation(annotation)
        //mapView.showAnnotations([annotation], animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted {
            self.getLocation()
        }
    }
    
    // MARK: - MapView Delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation.title! == "Current Location" ){
            return nil
        }
        
        let annotationReuseId = annotation.title!
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId!)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView!.annotation = annotation
        }
        
        anView!.canShowCallout = true;
        
        switch (annotationReuseId!) {
        case "Waste" :
            anView!.image = UIImage(named: "TrashPin")
            break
        case "Recycling" :
            anView!.image = UIImage(named: "RecyclePin")
            break
        case "Dog" :
            anView!.image = UIImage(named: "DogWastePin")
            break
        default: break
        }
        
        anView!.backgroundColor = UIColor.clearColor()
       
        let reportButton = UIButton(type: UIButtonType.Custom) as UIButton
        reportButton.frame.size.width = 44
        reportButton.frame.size.height = 44
        reportButton.setTitle("Report", forState: UIControlState.Normal)
        reportButton.addTarget(self, action: #selector(ViewController.reportButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        anView!.leftCalloutAccessoryView = reportButton
        
        return anView
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        getLocation()
    }
    
    func reportButtonPressed() {
        performSegueWithIdentifier("reportViewSegue", sender: self)
    }
    
}
