//
//  ApiRideController.swift
//  MapsApp
//
//  Created by Blanko Mac-dev on 27/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit
import GoogleMaps

class ApiRideController: UIViewController {
    
    var mapView: GMSMapView?

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func apiAction(_ sender: Any) {
        
    }

}
