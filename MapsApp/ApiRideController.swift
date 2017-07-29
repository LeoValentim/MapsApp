//
//  ApiRideController.swift
//  MapsApp
//
//  Created by Blanko Mac-dev on 27/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps

class ApiRideController: UIViewController, GoogleMapControllerDelegate {
    
    @IBOutlet weak var locationsFieldsView: UIView!
    @IBOutlet weak var googleMapContainer: UIView!
    
    var oldLocationsFieldsViewBounds: CGRect = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoogleMapController,
            segue.identifier == "GoogleMapControllerSegue" {
            vc.delegate = self
        }
    }
    
    func googleMapView(_ mapView: GMSMapView, didClear googleMapController: GoogleMapController) {
        
    }
    
    func googleMapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController) {
        let marker = GMSMarker(position: coordinate)
        marker.title = "Destino"
        marker.map = mapView
        
        if let currentLocation = googleMapController.currentLocation {
            let origin = "\(currentLocation.latitude),\(currentLocation.longitude)"
            let destination = "\(coordinate.latitude),\(coordinate.longitude)"
            
            googleMapController.drawRoute(origin: origin, destination: destination, key: googleMapController.googleMapsKey) {
                routes in
                
                if routes.count > 0 {
                    
                }
            }
        }
    }
    
    func googleMapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController) {
        self.view.endEditing(true)
        googleMapController.clearMap()
    }

}
