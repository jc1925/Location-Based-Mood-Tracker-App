//
//  PinDataViewController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//

import UIKit

class PinDataViewController: UIViewController, SaveMoodDelegate {
    
    var pin: PinAnnotation!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var mean_label: UILabel!
    @IBOutlet var median_label: UILabel!
    @IBOutlet var min_label: UILabel!
    @IBOutlet var max_label: UILabel!
    @IBOutlet var moods: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = pin.name
        comment.text = pin.comment
        
        self.pin.updated = false
        
        let mean = pin.get_mean()
        let median = pin.get_median()
        let min = pin.get_min()
        let max = pin.get_max()
        
        

        if (mean == -1 || min == -1 || max == -1 || median == -1) {
            mean_label.text = "Mean: No Stat"
            median_label.text = "Median: No Stat"
            min_label.text = "Min: No Stat"
            max_label.text = "Max: No Stat"
        } else {
            mean_label.text = "Mean: \(mean)"
            median_label.text = "Median: \(median)"
            min_label.text = "Min: \(min)"
            max_label.text = "Max: \(max)"
        }
    }
    
    @IBAction func clickMood() {
        performSegue(withIdentifier: "toTableMood", sender: pin.mood)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTableMood") {
            if let destVC = segue.destination as? MoodTableViewController {
                destVC.moods = self.pin.mood_tracker
            }
        }
    }
    
    func didSave(_ moods: [Mood]) {
        dismiss(animated: false, completion: nil)
        self.pin.mood_tracker = moods
            
//            .insert(moods, at: self.pin.mood_tracker.count)
        self.pin.updated = false
    }
    
    
}
