//
//  EditWorkoutView.swift
//  BearFit
//
//  Created by Ryan Shih on 12/2/23.
//

import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @State var isAlerted: Bool = false
    @State var isExerciseAlerted: Bool = false
    var workout: Workout
    @State var currentName: String = ""
    @State var currentCaloriesBurned: String = ""
        
    var body: some View {
        @Environment(\.presentationMode) var presentationMode
        
        VStack {
            ExitButton()
            HStack{
                Text(workout.name)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                Button(action: {
                    currentName = ""
                    isAlerted.toggle()
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                .padding(5)
            }
            .alert("Edit Workout Name", isPresented: $isAlerted) {
                VStack {
                    TextField("Enter new name", text: $currentName)
                    TextField("Enter expected calories burned", text: $currentCaloriesBurned)
                    HStack {
                        Button(action: {
                            isAlerted.toggle()
                        }) {
                            Text("Cancel")
                        }
                        Button(action: {
                            workout.name = currentName
                            workout.expectedCaloriesBurned = Int(currentCaloriesBurned) ?? 0
                        }) {
                            Text("Confirm")
                        }
                    }
                }
            }
            Text("EXPECTED CALORIES BURNED: \(workout.expectedCaloriesBurned)")
                .font(.system(size: 18))
            VStack {    
                ForEach(workout.exercises.indices, id: \.self) { idx in
                    Button(action: {
                        workout.exercises.remove(at: idx)
                    }) {
                        HStack {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(workout.exercises[idx].name)
                                .font(.system(size: 20))
                        }
                    }
                }
                .frame(maxWidth: 340, alignment:.leading)
                
                HStack{
                    Button(action: {
                        currentName = ""
                        isExerciseAlerted.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("ADD EXERCISE")
                            .font(.system(size: 20))
                    }
                }
                .frame(maxWidth: 340, alignment:.leading)
                .alert("Add Exercise", isPresented: $isExerciseAlerted) {
                    VStack {
                        TextField("Enter exercise name", text: $currentName)
                        HStack {
                            Button(action: {
                                isAlerted.toggle()
                            }) {
                                Text("Cancel")
                            }
                            Button(action: {
                                let exercise = Exercise(name: currentName)
                                workout.exercises.append(exercise)
                            }) {
                                Text("Confirm")
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .foregroundColor(appBlue)
        .background(appGreen)
    }
}

#Preview {
    EditWorkoutView(workout: Workout(name: "New Workout", expectedCaloriesBurned: 300))
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}

