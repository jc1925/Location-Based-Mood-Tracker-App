//
//  PinTableController.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//

import UIKit

class PinsTableViewController: UITableViewController, AddPinDelegate {
    
    var pinAnnotations: [PinAnnotation]!

    
    override func viewDidLoad () {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinAnnotations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
        
        // set the text label
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = self.pinAnnotations[indexPath.row].name
        }

        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = self.pinAnnotations[indexPath.row].comment
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toPinAdd", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPinAdd") {
            if let dest = segue.destination as? UINavigationController {
                if let APVC = dest.topViewController as? AddPinViewController{
                    APVC.delegate = self
                }
            }
        }
    }
    
    func didCreate(_ pin: PinAnnotation) {
        dismiss(animated: true, completion: nil)
        let len = self.pinAnnotations.count
        pin.id = len + 1
        print(pin)
        self.pinAnnotations.insert(pin, at: len)
        self.tableView.reloadData()
        
        
    }
}
