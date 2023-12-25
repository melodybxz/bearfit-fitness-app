//
//  WorkoutView.swift
//  BearFit
//
//  Created by Sebastian Arevalo on 11/22/23.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    enum ActiveAlert {
        case first, second
    }
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var isSheetPresented: Bool = false
    var workout: Workout
    
        
    var body: some View {
        let user = users[0]
        VStack {
            ExitButton()
            Text(workout.name)
                .font(.system(size: 40))
                .fontWeight(.bold)
            Text("EXPECTED CALORIES BURNED: \(workout.expectedCaloriesBurned)")
                .font(.system(size: 18))
            Text("TIMES COMPLETED: \(workout.timesCompleted)")
                .font(.system(size: 18)).padding(.bottom)
            VStack {
                ForEach(workout.exercises.indices, id: \.self) { idx in
                    let exercise = workout.exercises[idx]
                    Button(action: {
                        exercise.completed.toggle()
                    }) {
                        HStack {
                            exercise.completed
                                ? Image(systemName: "checkmark.circle.fill").resizable().frame(width: 24, height: 24)
                                : Image(systemName: "circle").resizable().frame(width: 24, height: 24)
                            Text(exercise.name)
                                .font(.system(size: 20))
                        }
                    }
                }
                .frame(maxWidth: 340, alignment:.leading)
                BlueButton(displayText: "COMPLETE") {
                    if hasCompleted(exercises: workout.exercises) {
                        workout.timesCompleted += 1
                        user.currentCompletion += 1
                        let weightLost = round(Float(workout.expectedCaloriesBurned) / 7700.0 * 100) / 100.0
                        user.currentWeightLost += weightLost
                        self.activeAlert = .first
                    } else {
                        self.activeAlert = .second
                    }
                    self.showAlert = true
                }.padding()
                GreenButton(displayText: "EDIT") {
                    isSheetPresented.toggle()
                }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
            Spacer()
        }
        .padding()
        .foregroundColor(appBlue)
        .background(appGreen)
        .alert(isPresented: $showAlert) {
            switch activeAlert {
                case .first:
                    return Alert(
                        title: Text("CONGRATS!!"),
                        message: Text("You've completed the workout. You've complete this workout \(workout.timesCompleted) times"),
                        dismissButton: .default(Text("OK"),
                            action: {
                                for index in workout.exercises.indices {
                                    workout.exercises[index].completed.toggle()
                                }
                        })
                    )
                case .second:
                    return Alert(
                        title: Text("WAIT!!"),
                        message: Text("Incomplete workout. Complete this workout after finishing all exercises!"),
                        dismissButton: .default(Text("OK"))
                    )
            }
            
        }
        .sheet(isPresented: $isSheetPresented) {
            EditWorkoutView(workout: workout)
        }
    }
    
    func hasCompleted(exercises: [Exercise]) -> Bool {
        for exercise in exercises {
            if !exercise.completed {
                return false
            }
        }
        return true
    }
}

#Preview {
    WorkoutView(workout: Workout(name: "Saitama's Workout", expectedCaloriesBurned: 10000, exercises: [
        Exercise(name: "100 pushups"),
        Exercise(name: "100 sit ups"),
        Exercise(name: "100 squats"),
        Exercise(name: "10 KM run")
    ], timesCompleted: 5))
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}
