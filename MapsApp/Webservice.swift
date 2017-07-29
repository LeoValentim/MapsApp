//
//  Webservice.swift
//  MapsApp
//
//  Created by Mac on 29/07/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import SwiftyJSON
import Foundation

struct Webservice {
    
    static func post(_ urlString: String, params: JSON, headers: [String:String], completion: @escaping (Data!) -> ()) {
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let group = DispatchGroup()
        var dataBody : Data!
        var resultData: Data!
        
        DispatchQueue.global().async {
            request.httpMethod = "POST"
            for (Key, Value) in headers {
                request.setValue(Value, forHTTPHeaderField: Key)
            }
            
            if (headers.filter{ h in h.value.lowercased() == "application/x-www-form-urlencoded" }).count > 0 {
                var param = ""
                for (Key, Value) in params {
                    if let val = Value.string {
                        let paramStringFormat = "\(Key)=\(val)"
                        param = (param != "" ? "\(param)&\(paramStringFormat)" : paramStringFormat)
                    }
                }
                dataBody = param.data(using: String.Encoding.utf8, allowLossyConversion: true)
            } else {
                dataBody = try? params.rawData(options: .prettyPrinted)
            }
            
            request.httpBody = dataBody!
            
            group.enter()
            
            session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                resultData = data
                group.leave()
            }).resume()
            
            _ = group.wait(timeout: DispatchTime.distantFuture)
            DispatchQueue.main.async {
                completion(resultData)
            }
        }
    }
    
    static func get(_ urlString: String, headers: [String:String], completion: @escaping (Data!) -> ()) {
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let group = DispatchGroup()
        var resultData: Data!
        
        DispatchQueue.global().async {
            
            request.httpMethod = "GET"
            for (Key, Value) in headers {
                request.setValue(Value, forHTTPHeaderField: Key)
            }
            
            group.enter()
            
            session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                resultData = data
                group.leave()
            }).resume()
            
            _ = group.wait(timeout: DispatchTime.distantFuture)
            DispatchQueue.main.async {
                completion(resultData)
            }
        }
    }
}
