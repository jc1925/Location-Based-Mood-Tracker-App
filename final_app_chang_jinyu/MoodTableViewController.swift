//
//  PinTableController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//

import UIKit

protocol SaveMoodDelegate: class {
    func didSave(_ moods: [Mood])
}


class MoodTableViewController: UITableViewController, AddMoodDelegate {
    
    var moods: [Mood]!
    
    weak var delegate: SaveMoodDelegate?

    override func viewDidLoad () {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodCell")!
        
        // set the text label
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = self.moods[indexPath.row].date
        }

        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = "\(self.moods[indexPath.row].mood)"
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toMoodAdd", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMoodAdd") {
            if let dest = segue.destination as? UINavigationController {
                if let AMVC = dest.topViewController as? AddMoodViewController{
                    AMVC.delegate = self
                }
            }
        }
    }

    func didCreate(_ mood: Mood) {
        dismiss(animated: true, completion: nil)
        self.moods.insert(mood, at: moods.count)
        self.tableView.reloadData()
        self.delegate?.didSave(moods!)
    }
}
