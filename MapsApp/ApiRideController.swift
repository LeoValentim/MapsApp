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
import GooglePlaces

class ApiRideController: UIViewController {
    
    var googlePlacesKey = "AIzaSyAnpQS1Ct7tG9Jet057u_AjHhOjOiPiwzo"
    
    @IBOutlet weak var origemTextField: UITextField!
    @IBOutlet weak var destinoTextField: UITextField!
    @IBOutlet weak var locationsFieldsView: UIView!
    @IBOutlet weak var googleMapContainer: UIView!
    
    var googleMapController: GoogleMapController!
    var origem: CLLocationCoordinate2D!
    var destino: CLLocationCoordinate2D!
    
    var oldLocationsFieldsViewY: CGFloat = 0.0
    var routeIsSetted = false
    var origemAutocompleteOpen = false
    var destinoAutocompleteOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey(self.googlePlacesKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func origemAction(_ sender: Any) {
        self.origemAutocompleteOpen = true
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func destinoAction(_ sender: Any) {
        self.destinoAutocompleteOpen = true
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

}

extension ApiRideController: GoogleMapControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoogleMapController,
            segue.identifier == "GoogleMapControllerSegue" {
            vc.delegate = self
            self.googleMapController = vc
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
        
        var origemCoordinateLocation: CLLocationCoordinate2D!
        if let origem = self.origem {
            origemCoordinateLocation = origem
        } else if let currentLocation = googleMapController.currentLocation {
            origemCoordinateLocation = currentLocation
        }
        
        guard let origemLocation = origemCoordinateLocation else {
            return
        }
        
        self.googleMapDrawRoute(googleMapController, origin: origemLocation, destination: coordinate) {
            let marker = GMSMarker(position: coordinate)
            marker.title = "Destino"
            marker.map = mapView
        }
    }
    
    func googleMapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D, googleMapController: GoogleMapController) {
        self.view.endEditing(true)
        googleMapController.clearMap()
    }
    
    func googleMapDrawRoute(_ googleMapController: GoogleMapController, origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, complition: (() -> Void)!){
        
        let originString = "\(origin.latitude),\(origin.longitude)"
        let destinationString = "\(destination.latitude),\(destination.longitude)"
        
        googleMapController.drawRoute(origin: originString, destination: destinationString, key: googleMapController.googleMapsKey) {
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
            
            if let compli = complition {
                compli()
            }
        }
    }
    
}

extension ApiRideController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if self.origemAutocompleteOpen {
            self.origemTextField.text = place.formattedAddress
            self.origem = place.coordinate
        } else {
            self.destinoTextField.text = place.formattedAddress
            self.destino = place.coordinate
        }
        
        if let ori = self.origem, let dest = self.destino, let mapController = self.googleMapController {
            self.googleMapDrawRoute(mapController, origin: ori, destination: dest) {
                let marker = GMSMarker(position: dest)
                marker.title = "Destino"
                marker.map = mapController.mapView
            }
        }
        
        self.origemAutocompleteOpen = false
        self.destinoAutocompleteOpen = false
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
