//
//  AddMoodViewController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//


import UIKit

protocol AddMoodDelegate: class {
    func didCreate(_ mood: Mood)
}

class AddMoodViewController: UIViewController {
    @IBOutlet var date: UITextField!
    @IBOutlet var mood: UITextField!
    @IBOutlet var comment: UITextField!
    
    weak var delegate: AddMoodDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createNewMood() -> Mood? {
        if (date.text != "" && mood.text != "") {
            let mood_num: Int = Int(mood.text!) ?? -1
            if (mood_num < 0 || mood_num > 10) {
                return nil
            }
            return Mood(date: date.text!, mood: mood_num, description: comment.text)
        }
        return nil
    }
    
    @IBAction func cancelMood() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveMood() {
        let newMood = createNewMood()
        if (newMood != nil) {
            self.delegate?.didCreate(newMood!)
        }
    }
}

