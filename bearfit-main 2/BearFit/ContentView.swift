//
//  ContentView.swift
//  BearFit
//
//  Created by Yale Han on 11/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        LaunchPage()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}
