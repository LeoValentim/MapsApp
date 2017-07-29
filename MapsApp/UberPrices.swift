//
//  UberPrices.swift
//  MapsApp
//
//  Created by Blanko Mac-dev on 27/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UberPrice {
    var localized_display_name: String
    var distance: Float
    var display_name: String
    var product_id: String
    var high_estimate: Int
    var low_estimate: Int
    var duration: Int
    var estimate: String
    var currency_code: String
    
    init(from json: JSON) {
        localized_display_name = (json["localized_display_name"].exists() ? json["localized_display_name"].string! : "")
        distance = (json["distance"].exists() ? json["distance"].float! : 0.0)
        display_name = (json["display_name"].exists() ? json["display_name"].string! : "")
        product_id = (json["product_id"].exists() ? json["product_id"].string! : "")
        high_estimate = (json["high_estimate"].exists() ? json["high_estimate"].int! : 0)
        low_estimate = (json["low_estimate"].exists() ? json["low_estimate"].int! : 0)
        duration = (json["duration"].exists() ? json["duration"].int! : 0)
        estimate = (json["estimate"].exists() ? json["estimate"].string! : "")
        currency_code = (json["currency_code"].exists() ? json["currency_code"].string! : "")
    }
}
