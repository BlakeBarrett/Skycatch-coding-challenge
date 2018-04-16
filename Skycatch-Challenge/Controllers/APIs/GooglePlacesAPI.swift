//
//  GooglePlacesAPI.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/16/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import Foundation
import CoreLocation

protocol GooglePlacesAPIDelegate: class {
    func onLocationLoaded(_ value: JSON)
}

// info on how to use Google's Places API can be found here: https://developers.google.com/places/web-service/details
class GooglePlacesAPI {
    
    static let apiKey = "AIzaSyBJKGKZpfo-ta6zPkz5uad1LjYOJZc32kI"
    static let sanFranciscoString = "37.773972,-122.431297"
    
    static let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    let apiUrlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&sensor=false&location=\(sanFranciscoString)&rankby=distance&keyword="
    
    weak var delegate: GooglePlacesAPIDelegate?
    
    func apiSearchUrl(for place: String) -> URL? {
        let urlString = apiUrlString + place.replacingOccurrences(of: " ", with: "%20")
        return URL(string: urlString)
    }
    
    func fetchLocations(for movie: Row) {
        guard let url = apiSearchUrl(for: movie.location) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            if let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data) as? JSON,
                let json = jsonData {
                
                if let location = ((((json["results"] as? [JSON])?.first)?["geometry"] as? JSON)?["location"] as? JSON) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self?.delegate?.onLocationLoaded(location)
                    })
                }
            }
        }
        dataTask.resume()
    }
}
