//
//  HomePage.swift
//  BearFit
//
//  Created by Yale Han on 11/22/23.
//

import Foundation
import SwiftUI
import SwiftData

var currWorkout = -1

struct HomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    @Query var users: [User]
    @State private var isWorkoutPresented = false
    @State private var isEditWorkoutPresented = false
    @State private var isEditAllWorkoutsPresented = false
    
    var body: some View {
        let user = users[0]
        VStack (spacing: 5) {
            ZStack (alignment: .top, content: {
                ProfilePicture()
                Header(name: user.name)
            })
            Progress(completionProgress: user.currentCompletion,
                     completionGoal: user.completionGoal,
                     weightProgress: user.currentWeightLost,
                     weightGoal: user.weightLostGoal
            )
                .padding(.bottom)
            WorkoutsCarousel(isWorkoutPresented: $isWorkoutPresented, 
                isEditWorkoutPresented: $isEditWorkoutPresented
            )
            BlueButton(displayText: "EDIT WORKOUTS") {
                isEditAllWorkoutsPresented.toggle()
            }.padding(EdgeInsets(top: 22, leading: 0, bottom: 0, trailing: 0))
            Spacer()
        }
        .background(appGreen)
        .sheet(isPresented: $isEditWorkoutPresented) {
            let workout = workouts[currWorkout]
            EditWorkoutView(workout: workout)
        }
        .sheet(isPresented: $isWorkoutPresented) {
            WorkoutView(workout: workouts[currWorkout])
        }
        .sheet(isPresented: $isEditAllWorkoutsPresented) {
                EditAllWorkoutsView()
        }
        
    }
}

struct ProfilePicture: View {
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    @Query var users: [User]
    @State private var isUserInfoPagePresented = false

    var body: some View {
        let user = users[0]
        Button(action: {
            if workouts.count == 0 {
                user.mostCompletedWorkout = "N/A"
            } else {
                var mostCompleted = 0
                var mostCompletedWorkout = ""
                for workout in workouts {
                    if workout.timesCompleted > mostCompleted {
                        mostCompleted = workout.timesCompleted
                        mostCompletedWorkout = workout.name
                    }
                }
                user.mostCompletedWorkout = mostCompletedWorkout
            }
            isUserInfoPagePresented.toggle()
        }) {
            HStack {
                Spacer()
                Image("pfp")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isUserInfoPagePresented) {
            UserInfoPage()
        }
    }
}



struct Header: View {
    @Environment(\.modelContext) private var modelContext
    var name: String
    
    var body: some View {
        VStack (spacing: -8) {
            Image("logo").resizable().frame(width: 140, height: 140)
            Text("You're on a roll,").font(.system(size: 28)).foregroundColor(appBlue)
            Text(name.uppercased()).fontWeight(.heavy).font(.system(size: 70)).foregroundColor(appBlue)
        }
    }
}

struct Progress: View {
    @Environment(\.modelContext) private var modelContext
    var completionProgress: Int
    var completionGoal: Int
    var weightProgress: Float
    var weightGoal: Float
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(appBlue)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
                .frame(width: 363, height: 176)
            VStack {
                Text("YOUR PROGRESS")
                    .fontWeight(.bold).foregroundColor(.white).font(.system(size: 26))
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                HStack {
                    Text("Current Streak: " + String(completionProgress))
                    Spacer()
                    Text("Goal: " + String(completionGoal))
                }.foregroundColor(.white)
                ProgressBar(value: Float(completionProgress) / Float(completionGoal), barWidth: 10, backgroundColor: Color(.white), fillColor: appPaleGreen)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                HStack {
                    Text("Weight Lost: " + String(weightProgress))
                    Spacer()
                    Text("Goal: " + String(weightGoal))
                }.foregroundColor(.white)
                ProgressBar(value: weightProgress / weightGoal, barWidth: 10, backgroundColor: Color(.white), fillColor: appPaleGreen)
                Spacer()
            }
            .frame(width: 320, height: 140)
        }
    }
}

struct ProgressBar: View {
    @Environment(\.modelContext) private var modelContext
    var value: Float
    var barWidth: CGFloat
    var backgroundColor: Color
    var fillColor: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: barWidth)
                    .foregroundColor(backgroundColor)

                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: barWidth, alignment: .leading)
                    .foregroundColor(fillColor)
            }
        }
    }
}

struct WorkoutsCarousel: View {
    @Binding var isWorkoutPresented: Bool
    @Binding var isEditWorkoutPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(appBlue)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
            VStack {
                Text("YOUR WORKOUTS")
                    .fontWeight(.bold).foregroundColor(.white).font(.system(size: 26))
                    .padding(EdgeInsets(top: 25, leading: 0, bottom: 2, trailing: 0))
                TabView {
                    if !workouts.isEmpty {
                        ForEach(workouts.indices, id: \.self) { idx in
                            if workouts.count < 0 {
                                DefaultWorkoutsCarousel()
                            } else {
                                let workout = workouts[idx]
                                WorkoutTab(workout: workout,
                                   workoutIdx: idx,
                                   isWorkoutPresented: $isWorkoutPresented,
                                   isEditWorkoutPresented: $isEditWorkoutPresented
                                )
                                    .tabItem {
                                        Text("Tab \(idx + 1)")
                                    }
                                    .tag(idx + 1)
                            }
                        }
                    } else {
                        DefaultWorkoutsCarousel()
                    }
                }
                .tabViewStyle(PageTabViewStyle()) // Optional: Use PageTabViewStyle for a swipeable UI
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }.frame(width: 363, height: 254)
    }
}

struct WorkoutTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    var workout: Workout
    var workoutIdx: Int
    @Binding var isWorkoutPresented: Bool
    @Binding var isEditWorkoutPresented: Bool
    
    var body: some View {
        VStack {
            VStack {
                Text(workout.name).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.system(size: 20))
                Text("Times Completed: " + String(workout.timesCompleted)).font(.system(size: 18))
            }
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            VStack (spacing: 22) {
                GreenButton(displayText: "EDIT") {
                    currWorkout = workoutIdx
                    isEditWorkoutPresented.toggle()
                }
                GreenButton(displayText: "BEGIN") {
                    currWorkout = workoutIdx
                    isWorkoutPresented.toggle()
                }
            }
            Spacer()
        }
    }
}

struct DefaultWorkoutsCarousel: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Text("Create or add a new workout!")
            .foregroundColor(.white)
            .font(.system(size: 20))
            .multilineTextAlignment(.center)
            .frame(width: 200)
            .padding(EdgeInsets(top: -5, leading: 0, bottom: 30, trailing: 0))
    }
}

#Preview {
    HomePage()
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}
