//
//  AddPinViewController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/6/21.
//

import UIKit
import MapKit

protocol AddPinDelegate: class {
    func didCreate(_ pin: PinAnnotation)
}

class AddPinViewController: UIViewController {
    @IBOutlet var name: UITextField!
    @IBOutlet var comment: UITextField!
    @IBOutlet var longtitude: UITextField!
    @IBOutlet var latitude: UITextField!
    var coord: CLLocationCoordinate2D?
    
    weak var delegate: AddPinDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    //39.9581870
    //-75.210350
    
    func createNewPin() -> PinAnnotation? {
        if (name.text != "") {
            if (longtitude.text != "" && latitude.text != "") {
                self.coord = CLLocationCoordinate2D(latitude: Double(latitude.text!) ?? 39.951870, longitude: Double(longtitude.text!) ?? -75.190350)
                print("\(latitude.text!)")
                print("\(longtitude.text!)")
            }
            let location = CLLocationCoordinate2D(latitude: 39.951870, longitude: -75.190350)
            return PinAnnotation(coordinate: self.coord ?? location, id: -1, name: name.text!, comment: comment.text, mood: [Mood]())
        }
        return nil
    }
    
    @IBAction func cancelContact() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveContact() {
        let newPin = createNewPin()
        if (newPin != nil) {
            self.delegate?.didCreate(newPin!)
        }
    }
    

}
