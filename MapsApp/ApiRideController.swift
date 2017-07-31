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
    
    var oldLocationsFieldsViewY: CGFloat = 0.0
    var routeIsSetted = false
    
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
        
        if self.routeIsSetted {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.locationsFieldsView.frame.origin.y = self.oldLocationsFieldsViewY
            }, completion: nil)
        }
        self.routeIsSetted = false
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
                    if !self.routeIsSetted {
                        self.oldLocationsFieldsViewY = self.locationsFieldsView.frame.origin.y
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                            self.locationsFieldsView.frame.origin.y -= self.locationsFieldsView.frame.height
                        }, completion: nil)
                    }
                    self.routeIsSetted = true
                }
            }
        }
    }
    
    func googleMapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController) {
        self.view.endEditing(true)
        googleMapController.clearMap()
    }

}
