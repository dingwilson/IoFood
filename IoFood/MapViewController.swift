//
//  MapViewController.swift
//  IoFood
//
//  Created by Wilson Ding on 3/27/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.showsUserLocation = true
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

        showNearby()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNearby() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "supermarket"
        request.region = map.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler{
            (response: MKLocalSearchResponse?, error: NSError?) in
            if let items = response?.mapItems
            {
                for item in items{
                    print("Item name = \(item.name)")
                    print("Latitude = \(item.placemark.location!.coordinate.latitude)")
                    print("Longitude = \(item.placemark.location!.coordinate.longitude)")
                    
                    let anotation = MKPointAnnotation()
                    anotation.coordinate = CLLocationCoordinate2DMake(item.placemark.location!.coordinate.latitude, item.placemark.location!.coordinate.longitude)
                    anotation.title = item.name
                    self.map.addAnnotation(anotation)
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11))
        
        self.map.setRegion(region, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
