//
//  PinAnnotation.swift
//  final_app_chang_jinyu
//
//  Created by i on 12/2/21.
//

import UIKit
import MapKit

class PinAnnotation: MKPointAnnotation {
    var id: Int
    var name: String
    var comment: String
    var mood_tracker: [Mood]
    var mood: [Int]
    var updated: Bool
    // if thhe mood is not the most current version for mood_tracker, it's false
    
    init(coordinate: CLLocationCoordinate2D, id: Int, name: String, comment: String?, mood: [Mood]?) {
        self.id = id
        self.comment = comment ?? "This person is lazy and didn't leave any comment."
        self.name = name
        self.mood_tracker = mood ?? [Mood]()
        self.mood = [Int]()
        self.updated = false
        
        super.init()
        self.coordinate = coordinate
    }
    
    // update the mood list with all the mood stored in mood_tracker
    func get_mood_num() {
        self.mood = [Int]()
        for tracker in self.mood_tracker {
            let mood_num: Int = tracker.mood
            self.mood.append(mood_num)
        }
        self.updated = true
    }
    
    // return the mean of mood
    func get_mean() -> Double {
        if (!updated) {
            get_mood_num()
        }
        if (self.mood.isEmpty) {
            return -1
        } else {
            return Double(self.mood.reduce(0, +)) / Double(self.mood.count)
        }
    }
    
    // return the median of mood
    func get_median() -> Int {
        if (!updated) {
            get_mood_num()
        }
        if (self.mood.isEmpty) {
            return -1
        } else {
            return self.mood.sorted(by: <)[self.mood.count / 2]
        }
    }
    
    // return the min of mood
    func get_min() -> Int {
        if (!updated) {
            get_mood_num()
        }
        
        return mood.min() ?? -1
    }
    
    // return the max of mood
    func get_max() -> Int {
        if (!updated) {
            get_mood_num()
        }
        
        return mood.max() ?? -1
    }
}

class Mood {
    var description: String
    var date: String
    var mood: Int
    
    init(date: String, mood: Int, description: String?) {
        self.mood = mood
        self.date = date
        self.description = description ?? ""
    }
}
