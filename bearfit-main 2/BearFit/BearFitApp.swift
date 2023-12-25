//
//  BearFitApp.swift
//  BearFit
//
//  Created by Yale Han on 11/22/23.
//

import SwiftUI
import SwiftData

@main
struct BearFitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Workout.self, Exercise.self, User.self])
        }
    }
}
