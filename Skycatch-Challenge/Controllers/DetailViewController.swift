//
//  DetailViewController.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/5/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    let reuseIdentifier = "LocationCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    let placesAPI = GooglePlacesAPI()

    var annotations = [MKAnnotation]()
    var rows: [Row]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(GooglePlacesAPI.sanFrancisco, 20_000, 20_000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        placesAPI.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = rows?[indexPath.row].location
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetchLocation(for: rows?[indexPath.row])
    }
}

extension DetailViewController: GooglePlacesAPIDelegate {

    func fetchLocation(for value: Row?) {
        guard let value = value else { return }
        placesAPI.fetchLocations(for: value)
    }
    
    func onLocationLoaded(_ value: JSON) {
        
        guard let lat = value["lat"],
              let long = value["lng"],
              let latDouble = Double(String(describing: lat)),
              let longDouble = Double(String(describing: long)) else { return }
        
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latDouble, longitude: longDouble)
        
        self.annotations.append(annotation)
        mapView.addAnnotations(annotations)
    }
}
