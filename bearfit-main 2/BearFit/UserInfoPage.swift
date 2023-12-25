//
//  UserInfoPage.swift
//  BearFit
//
//  Created by zbx‘s macbook on 2023/11/30.
//

import Foundation
import SwiftUI
import SwiftData

struct UserInfoPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]
    var body: some View {
        let user = users[0]
        ScrollView {
            VStack {
                ExitButton()
                AvatarCircle()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                UserInfoSection(title: "BASIC INFORMATION", content: {
                    UserInfoField(title: "Height", value: "\(user.height) cm")
                    UserInfoField(title: "Weight", value: "\(user.weight - user.currentWeightLost) kg")
                    UserInfoField(title: "BMI", value: "\(user.bmi)")
                    }, sectionHeight: 150)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 28, trailing: 0))
                UserInfoSection(title: "PREFERENCES", content: {
                        UserInfoField(title: "Workout Types", value: "\(user.workoutTypes)") 
                        UserInfoField(title: "Frequencies", value: "\(user.frequency) times/week")
                    }, sectionHeight: 115)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0))
                UserInfoSection(title: "GOALS", content: {
                        UserInfoField(title: "Workouts Completed", value: "\(user.completionGoal)")
                        UserInfoField(title: "Weight Lost", value: "\(user.weightLostGoal) kg")
                    }, sectionHeight: 112)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0))
                UserInfoSection(title: "WORKOUT STATS", content: {
                        UserInfoField(title: "Favorite Workout", value: "\(user.mostCompletedWorkout)")
                        UserInfoField(title: "Workouts Completed", value: "\(user.currentCompletion)")
                        UserInfoField(title: "Weight Lost", value: "\(user.currentWeightLost) kg")
                    }, sectionHeight: 145)
                Spacer()
            }
            .padding()
        }
        .background(appGreen)
    }
}
    
struct AvatarCircle: View {
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]
    @State var isAlerted: Bool = false
    @State var currentName: String = ""
    @State var currentHeight: String = ""
    @State var currentWeight: String = ""
    @State var currentPreferences: String = ""
    @State var currentFrequency: String = ""
    @State var completionGoal: String = ""
    @State var weightGoal: String = ""
    
    var body: some View {
        let user = users[0]
        VStack (spacing: 5) {
            Image("pfp")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
            HStack{
                Text("\(user.name)")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(appBlue)
                Button(action: {
                    currentName = ""
                    currentHeight = ""
                    currentWeight = ""
                    currentPreferences = ""
                    currentFrequency = ""
                    completionGoal = ""
                    weightGoal = ""
                    isAlerted.toggle()
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(appBlue)
                }
                .padding(5)
                .alert("Edit Workout Name", isPresented: $isAlerted) {
                    VStack {
                        TextField("Enter your name", text: $currentName)
                        TextField("Enter your height (in cm)", text: $currentHeight)
                        TextField("Enter your weight (in kg)", text: $currentWeight)
                        TextField("Enter your favorite workout types", text: $currentPreferences)
                        TextField("Enter how many times you work out a week", text: $currentFrequency)
                        TextField("Enter your completion goal", text: $completionGoal)
                        TextField("Enter your weight loss goal", text: $weightGoal)
                        HStack {
                            Button(action: {
                                isAlerted.toggle()
                            }) {
                                Text("Cancel")
                            }
                            Button(action: {
                                let raw_height = Float(currentHeight) ?? 0.0
                                let raw_weight = Float(currentWeight) ?? 0.0
                                let real_weight = round(raw_weight * 100) / 100.0
                                let raw_bmi = raw_weight / pow(raw_height / 100.0, 2)
                                user.currentWeightLost = 0
                                user.currentCompletion = 0
                                user.name = currentName
                                user.height = round(raw_height * 100) / 100.0
                                user.weight = real_weight
                                user.bmi = round(raw_bmi * 100) / 100.0
                                user.workoutTypes = currentPreferences
                                user.frequency = Int(currentFrequency) ?? 0
                                user.completionGoal = Int(completionGoal) ?? 0
                                user.weightLostGoal = Float(weightGoal) ?? 0
                            }) {
                                Text("Confirm")
                            }
                        }
                    }
                }
            }
        }
    }
}
    
struct UserInfoSection<Content: View>: View {
    var title: String
    var content: Content
    var sectionHeight: CGFloat
    
    init(title: String, @ViewBuilder content: () -> Content, sectionHeight: CGFloat) {
        self.title = title
        self.content = content()
        self.sectionHeight = sectionHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Text(title)
                    .fontWeight(.bold).foregroundColor(.white).font(.system(size: 24))
                Spacer()
            }
            content
        }
        .background(RoundedRectangle(cornerRadius: 40)
            .fill(appBlue)
            .frame(width: 363, height: sectionHeight)
            .foregroundColor(.clear)
            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2))
    }
}
    
struct UserInfoField: View {
    var title: String
    var value: String
    
    var body: some View {
        Text("\(title): \(value)")
            .foregroundColor(.white)
            .font(.system(size: 18))
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            .frame(width: 340, alignment: .leading)
    }
}
    

#Preview {
    UserInfoPage()
        .modelContainer(for: [Workout.self, Exercise.self, User.self])
}
