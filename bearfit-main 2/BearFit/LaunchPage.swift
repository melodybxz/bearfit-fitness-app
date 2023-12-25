//
//  LaunchPage.swift
//  BearFit
//
//  Created by Yale Han on 11/22/23.
//

import Foundation
import SwiftUI
import SwiftData

struct LaunchPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]
    @State private var tapped: Bool = false
    
    var body: some View {
        ZStack {
            appGreen.ignoresSafeArea()
            if tapped {
                HomePage()
            } else {
                Button(action: {
                    if users.count == 0 {
                        let defaultUser = User(name: "OSKI", height: 170.0, weight: 70.0)
                        modelContext.insert(defaultUser)
                    }
                    self.tapped.toggle()
                }) {
                    VStack (spacing: -10) {
                        Spacer()
                        Text("Welcome to").font(.system(size: 28)).foregroundColor(appBlue)
                        Text("BEARFIT").fontWeight(.heavy).font(.system(size: 70)).foregroundColor(appBlue)
                        Image("logo").resizable().frame(width: 380, height: 380)
                        Text("tap to continue").fontWeight(.bold).font(.system(size: 20)).foregroundColor(appBlue)
                        Spacer()
                    }
                }
            }
        }
    }
}


#Preview {
    LaunchPage()
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}
