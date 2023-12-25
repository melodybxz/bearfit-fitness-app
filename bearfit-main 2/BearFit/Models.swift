//
//  Models.swift
//  BearFit
//
//  Created by Sebastian Arevalo on 11/30/23.
//

import Foundation
import SwiftData

@Model
class Workout {
    var name: String
    var expectedCaloriesBurned: Int
    var difficulty: Int
    var timesCompleted: Int
    var exercises: [Exercise]
    
    init(name: String, expectedCaloriesBurned:Int, exercises: [Exercise] = [], difficulty: Int = 1, timesCompleted: Int = 0) {
        self.name = name
        self.expectedCaloriesBurned = expectedCaloriesBurned
        self.difficulty = difficulty
        self.timesCompleted = timesCompleted
        self.exercises = exercises
    }
}

@Model
class Exercise {
    var name: String
    var completed: Bool
    
    init(name: String, completed: Bool = false) {
        self.name = name
        self.completed = completed
    }
}

@Model
class User {
    var name: String
    var height: Float   // In centimeters
    var weight: Float   // In kilograms
    var bmi: Float
    var workoutTypes: String = "N/A"
    var frequency: Int = 3
    var completionGoal: Int = 5
    var weightLostGoal: Float = 5.0
    var currentCompletion: Int = 0
    var currentWeightLost: Float = 0.0
    var mostCompletedWorkout: String = "N/A"
    
    init(name: String, height: Float, weight:Float) {
        self.name = name
        self.height = round(height * 100) / 100.0
        self.weight = round(weight * 100) / 100.0
        let raw_bmi = weight / pow(height / 100.0, 2)
        self.bmi = round(raw_bmi * 100) / 100.0
    }
}
