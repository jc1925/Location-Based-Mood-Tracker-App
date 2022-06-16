//
//  MapViewController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//
//
//  ViewController.swift
//  egg-hunt
//
//  Copyright © 2021 University of Pennsylvania. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, AddPinDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var pinAnnotations: [PinAnnotation]!
    var oldPinAnnotations: [PinAnnotation]?
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        ref = Database.database().reference()
        
        self.mapView.removeAnnotations(oldPinAnnotations ?? [PinAnnotation]())
        self.mapView.addAnnotations(pinAnnotations)
        oldPinAnnotations = pinAnnotations
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        centerMapOnPennCampus()

        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    func centerMapOnPennCampus() {
        let campusCenter = CLLocationCoordinate2D(latitude: 39.951870, longitude: -75.190350)
        let regionRadius: CLLocationDistance = 2000
        let region = MKCoordinateRegion(center: campusCenter, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func addPin() {
//        centerMapAtUserLocation()
        currentLocation = locationManager.location
        let coordinate = currentLocation?.coordinate
//        let annotation = MKPointAnnotation()
        if let coord = coordinate {
//            annotation.coordinate = coord
            performSegue(withIdentifier: "mapToPinAdd", sender: coord)
            
            
//            mapView.addAnnotation(annotation)
        } else {
            print("Failed to add annotation")
        }
    }
    
//    func centerMapAtUserLocation() {
//        currentLocation = locationManager.location
//        let regionRadius: CLLocationDistance = 2000
//        if let location = currentLocation {
//            let center = location.coordinate
//            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//            mapView.setRegion(region, animated: true)
//        } else {
//            print("Failed to center location.")
//        }
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "mapToData" {
            if let pin = sender as? PinAnnotation {
                if let destVC = segue.destination as? PinDataViewController {
                    destVC.pin = pin;
                }
            }
        } else if (segue.identifier == "mapToPinAdd") {
            if let dest = segue.destination as? UINavigationController {
                if let APVC = dest.topViewController as? AddPinViewController{
                    if let coord = sender as? CLLocationCoordinate2D {
                        APVC.coord = coord
                        APVC.delegate = self
                    }
                }
            }
        }
    }
    
    func didCreate(_ pin: PinAnnotation) {
        dismiss(animated: true, completion: nil)
        let len = self.pinAnnotations.count
        pin.id = len + 1
        print(pin.name)
        self.pinAnnotations.insert(pin, at: len)
        mapView.addAnnotation(pin)
        self.oldPinAnnotations = pinAnnotations
//        self.ref.child("pins").updateChildValues([pin.id: ])
//        self.ref.child("pins").child(String(eggAnnotation.id)).updateChildValues(["collected" : eggAnnotation.isCollected])
    }
}


// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    // TODO: Implement
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "PinAnnotationIdentifier"
        guard let pinAnnotation = annotation as? PinAnnotation else { return nil }
        
        // deque an annotation view with the identifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: pinAnnotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = pinAnnotation
        }
        
        // configure the callout view
        annotationView!.canShowCallout = true
        annotationView!.image = UIImage(named: "pin")
        
        let mean = pinAnnotation.get_mean()
        let min = pinAnnotation.get_min()
        let max = pinAnnotation.get_max()
        
        annotationView!.detailCalloutAccessoryView = getCalloutLabel(name: pinAnnotation.name, mean: mean, min: min, max: max)
        annotationView!.rightCalloutAccessoryView = getCalloutButton()
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let button = view.rightCalloutAccessoryView as? UIButton {
            if let pinAnnotation = view.annotation as? PinAnnotation {
                performSegue(withIdentifier: "mapToData", sender: pinAnnotation)
            }
        }
    }
    

    

    
    // This function should not require modification
    private func getCalloutLabel(name: String, mean: Double, min: Int, max: Int) -> UILabel {
        let label = UILabel()
        if (mean == -1 || min == -1 || max == -1) {
            label.text = name + ": No Stat"
        } else {
            label.text = name + ": mean: \(mean), min: \(min), max: \(max)"
        }
        return label
    }
    
    // This function should not require modification
    private func getCalloutButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Detail", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        return button
    }
    

}
