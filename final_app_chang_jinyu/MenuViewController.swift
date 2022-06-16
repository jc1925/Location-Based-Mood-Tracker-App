//
//  MenuViewController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//

import UIKit
import Firebase
import MapKit

class MenuViewController: UIViewController {
    
    @IBOutlet var map: UIButton!
    @IBOutlet var pins: UIButton!
    @IBOutlet var data: UIButton!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var pinAnnotations = [PinAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        refHandle = ref.child("pins").observe(DataEventType.value) { (snapshot) in
            if let pins = snapshot.value as? [NSDictionary] {
                DispatchQueue.main.async {
                    // remove existing pin annotations
                    self.pinAnnotations = [PinAnnotation]()
                    
                    // decode into array of EggAnnotations
                    for pin in pins {
                        let id = pin["Id"] as? Int
                        let name = pin["name"] as? String
                        let comment = pin["comment"] as? String
                        let lat = pin["lat"] as? Double
                        let long = pin["long"] as? Double
                        let coord = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                        var mood_list = [Mood]()
                        if let moods = pin["mood"] as? [NSDictionary] {
                            for data in moods {
                                let description = data["description"] as? String
                                let date = data["date"] as? String
                                let mood = data["mood"] as? Int
                                let result_data = Mood(date: date!, mood: mood!, description: description!)
                                mood_list.append(result_data)
                            }
                        }
                        
                        let pinAnnotation = PinAnnotation(coordinate: coord, id: id!, name: name!, comment: comment, mood: mood_list)
                        
                        self.pinAnnotations.append(pinAnnotation)
                    }
                }
            } else {
                print("Failed to retrieve data")
            }
        }
    }
    
    @IBAction func toPinsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toPins", sender: sender)
    }
    
    @IBAction func toMapButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: sender)
    }
    
    @IBAction func toStatButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toStat", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPins") {
            if let destVC = segue.destination as? PinsTableViewController {
                destVC.pinAnnotations = self.pinAnnotations
            }
        } else if (segue.identifier == "toMap") {
            if let destVC = segue.destination as? MapViewController {
                destVC.pinAnnotations = self.pinAnnotations
            }
        } else if (segue.identifier == "toStat") {
            if let destVC = segue.destination as? AllDataViewController {
                destVC.pinAnnotations = self.pinAnnotations
            }
        }
    }


}
