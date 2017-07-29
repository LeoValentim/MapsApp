//
//  GoogleMapController.swift
//  MapsApp
//
//  Created by Mac on 29/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

protocol GoogleMapControllerDelegate {
    func googleMapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController)
    func googleMapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController)
    func googleMapView(_ mapView: GMSMapView, didClear googleMapController: GoogleMapController)
}

extension GoogleMapControllerDelegate {
    func googleMapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController) {}
    
    func googleMapView(_ mapView: GMSMapView, didClear googleMapController: GoogleMapController){}
}

class GoogleMapController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapView: GMSMapView?
    var currentLocation: CLLocationCoordinate2D!
    var googleMapsKey = "AIzaSyBA4L5QBzzd6NvkQb958VYD4YFcLb_bPfs"
    let locationManager = CLLocationManager()
    
    var delegate: GoogleMapControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey(googleMapsKey)
        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: -23.543293, longitude: -46.638592)
        let cameraPosition = GMSCameraPosition.camera(withTarget: cameraPositionCoordinates, zoom: 12)
        
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPosition)
        self.mapView?.isMyLocationEnabled = true
        self.mapView?.delegate = self
        
        self.view = mapView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    // -------------- CLLocationManagerDelegate -------------- //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = manager.location!.coordinate
        
        if self.currentLocation == nil {
            let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
            self.mapView?.animate(to: GMSCameraPosition.camera(withTarget: cameraPositionCoordinates, zoom: 15))
        }
        
        self.currentLocation = loc
    }
    // -------------- CLLocationManagerDelegate -------------- //
    
    // -------------- GMSMapViewDelegate -------------- //
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if let del = self.delegate {
            del.googleMapView(mapView, didLongPressAt: coordinate, googleMapController: self)
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.view.endEditing(true)
        if let del = self.delegate {
            del.googleMapView(mapView, didTapAt: coordinate, googleMapController: self)
        }
    }
    // -------------- GMSMapViewDelegate -------------- //
    
    func clearMap(){
        self.mapView?.clear()
        if let del = self.delegate {
            del.googleMapView(self.mapView!, didClear: self)
        }
    }
    
    func drawRoute(origin: String, destination: String, key: String, complition: (([GMSPolyline]) -> Void)!) {
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(key)"
        
        Webservice.get(urlString, headers: [:]) {
            response in
            
            if let data = response {
                let json = JSON(data)
                var responceRoutes: [GMSPolyline] = []
                
                do{
                    let routes = json["routes"].array
                    self.mapView?.clear()
                    
                    for route in routes!
                    {
                        let points = route.dictionary?["overview_polyline"]?.dictionaryObject?["points"]
                        let path = GMSPath.init(fromEncodedPath: points! as! String)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 3
                        responceRoutes.append(polyline)
                        
                        let bounds = GMSCoordinateBounds(path: path!)
                        self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                        
                        polyline.map = self.mapView
                        
                    }
                } catch let error as NSError{
                    print("error:\(error)")
                }
                
                if let comp = complition {
                    comp(responceRoutes)
                }
            }
        }
    }

}
