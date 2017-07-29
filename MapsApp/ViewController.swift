//
//  ViewController.swift
//  MapsApp
//
//  Created by Mac on 23/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit
import GoogleMaps

class VacationDestination: NSObject {
    
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: GMSMapView?
    
    var currentDestination: VacationDestination?
    
    let locationManager = CLLocationManager()
    
    var destinations = [VacationDestination(name: "Galeria do Rock", location: CLLocationCoordinate2D(latitude: -23.543293, longitude: -46.638592), zoom: 15), VacationDestination(name: "Minha Casa", location: CLLocationCoordinate2D(latitude: -23.642446, longitude: -46.637669), zoom: 12)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey("AIzaSyBA4L5QBzzd6NvkQb958VYD4YFcLb_bPfs")
        let camera = GMSCameraPosition.camera(withLatitude: -23.642446, longitude: -46.637669, zoom: 12)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = self.mapView
        
        let currentLocation = CLLocationCoordinate2D(latitude: -23.642446, longitude: -46.637669)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Minha Casa"
        marker.map = self.mapView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(self.proximoLugar))
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func proximoLugar(){
        if let currentDes = self.currentDestination, let index = self.destinations.index(of: currentDes) {
            var nextIndex = index + 1
            if index >= self.destinations.count - 1 {
                nextIndex = 0
            }
            self.currentDestination = self.destinations[nextIndex]
        } else {
            self.currentDestination = self.destinations.first!
        }
        
        self.mapView?.animate(to: GMSCameraPosition.camera(withTarget: self.currentDestination!.location, zoom: self.currentDestination!.zoom))
        
        let marker = GMSMarker(position: self.currentDestination!.location)
        marker.title = self.currentDestination?.name
        marker.map = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }


}

