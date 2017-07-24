//
//  CaronaController.swift
//  MapsApp
//
//  Created by Mac on 23/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit
import UberRides
import CoreLocation

class CaronaController: UIViewController {
    
    let ridesClient = RidesClient()
    let button = RideRequestButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickupLocation = CLLocation(latitude: 37.775159, longitude: -122.417907)
        let dropoffLocation = CLLocation(latitude: 37.6213129, longitude: -122.3789554)
        
        //make sure that the pickupLocation and dropoffLocation is set in the Deeplink
        let builder = RideParametersBuilder()
            .setPickupLocation(pickupLocation)
            // nickname or address is required to properly display destination on the Uber App
            .setDropoffLocation(dropoffLocation,
                                nickname: "San Francisco International Airport")
        
        // use the same pickupLocation to get the estimate
        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
            product, response in
            if let productID = product?.productID { //check if the productID exists
                builder.setProductID(productID)
                self.button.rideParameters = builder.build()
                
                // show estimate in the button
                self.button.loadRideInformation()
            }
        })
        
        
        // center the button (optional)
        button.center = view.center
        
        //put the button in the view
        view.addSubview(button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
