//
//  EditAllWorkoutsView.swift
//  BearFit
//
//  Created by Sebastian Arevalo on 11/22/23.
//

import SwiftUI
import SwiftData

let presetWorkouts = [
    Workout(name: "Big C Hike", expectedCaloriesBurned: 200, exercises: [
        Exercise(name: "Hike up the Big C"),
        Exercise(name: "Enjoy the view of the university!")
    ], difficulty: 1),
    Workout(name: "RSF Leg Day", expectedCaloriesBurned: 400, exercises: [
        Exercise(name: "Stretch your legs"),
        Exercise(name: "Warm up with a light 15 min jog"),
        Exercise(name: "5 sets of dumbell squats, 10 reps per set"),
        Exercise(name: "3 sets of deadlifts, 5 reps per set"),
        Exercise(name: "3 sets of lunges, 15 reps per set"),
        Exercise(name: "Cool off at the RSF pool!")
    ], difficulty: 5),
    Workout(name: "Oski's Big Game Prep Workout", expectedCaloriesBurned: 1600, exercises: [
        Exercise(name: "Stretch your ENTIRE BODY"),
        Exercise(name: "Jog around Memorial Stadium 4 times"),
        Exercise(name: "Chop down some trees"),
        Exercise(name: "Do 20 push ups for each tree chopped"),
        Exercise(name: "Wrestle a bear"),
        Exercise(name: "March with the Cal Band"),
        Exercise(name: "Race against the other mascots")
    ], difficulty: 10)
]

struct EditAllWorkoutsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    @State var isEditWorkoutPresented: Bool = false
        
    var body: some View {
        VStack {
            ExitButton()
            EditWorkoutsCarousel(isEditWorkoutPresented: $isEditWorkoutPresented
            )
                .padding(.bottom)
            PresetWorkoutCarousel(isEditWorkoutPresented: $isEditWorkoutPresented)
            BlueButton(displayText: "NEW WORKOUT") {
                currWorkout = workouts.count
                let newWorkout = Workout(name: "New Workout", expectedCaloriesBurned: 0)
                modelContext.insert(newWorkout)
                isEditWorkoutPresented.toggle()
            }
            .padding(EdgeInsets(top: 22, leading: 0, bottom: 0, trailing: 0))
            Spacer()
        }
            .padding()
            .background(appGreen)
            .sheet(isPresented: $isEditWorkoutPresented) {
                EditWorkoutView(workout: workouts[currWorkout])
            }
        }
}

struct EditWorkoutsCarousel: View {
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    @Binding var isEditWorkoutPresented: Bool
    
    var body: some View {
        Text("EDIT WORKOUTS")
            .foregroundColor(appBlue)
            .font(.system(size: 40))
            .fontWeight(.bold)
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(appBlue)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                .frame(width: 363, height: 254)
            VStack {
                Text("YOUR WORKOUTS")
                    .foregroundColor(.white)
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: -1, trailing: 0))
                TabView {
                    if !workouts.isEmpty {
                        ForEach(workouts.indices, id: \.self) { idx in
                            let workout = workouts[idx]
                            VStack {
                                VStack {
                                    Text(workout.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    Text("Times Completed: \(workout.timesCompleted)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                VStack (spacing: 22) {
                                    GreenButton(displayText: "EDIT") {
                                        currWorkout = idx
                                        isEditWorkoutPresented.toggle()
                                    }
                                    GreenButton(displayText: "DELETE") {
                                        modelContext.delete(workout)
                                    }
                                }.padding(.bottom)
                                Spacer()
                            }.tabItem {
                                Text(String(idx))
                            }
                            .tag(idx)
                        }
                    } else {
                        DefaultWorkoutsCarousel()
                    }
                }
                .tabViewStyle(PageTabViewStyle()) // Optional: Use PageTabViewStyle for a swipeable UI
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            .frame(width: 320, height: 240)
        }
    }
}

struct PresetWorkoutCarousel: View {
    @Environment(\.modelContext) private var modelContext
    @Query var workouts: [Workout]
    @Binding var isEditWorkoutPresented: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(appBlue)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
                .frame(width: 363, height: 203)
            VStack {
                Text("PRESET WORKOUTS")
                    .foregroundColor(.white)
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: -1, trailing: 0))
                TabView {
                    ForEach(presetWorkouts.indices, id: \.self) { idx in
                        let workout = presetWorkouts[idx]
                        VStack {
                            VStack {
                                Text(workout.name)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                .fontWeight(.bold)
                                Text("Difficulty: \(workout.difficulty)/10").foregroundColor(.white)
                                    .font(.system(size: 18))
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                            VStack (spacing: 22) {
                                if !workouts.contains(workout) {
                                    GreenButton(displayText: "ADD") {
                                        modelContext.insert(workout)
                                    }
                                } else {
                                    NoActionButton(displayText: "ADDED", alertMessage: "You have already added this workout!")
                                }
                            }.padding(.bottom)
                            Spacer()
                        }.tabItem {
                            Text(String(idx))
                        }
                        .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle()) // Optional: Use PageTabViewStyle for a swipeable UI
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        .frame(width: 320, height: 189)
    }
}

#Preview {
    EditAllWorkoutsView()
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}
