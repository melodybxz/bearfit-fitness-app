//
//  Buttons.swift
//  BearFit
//
//  Created by Yale Han on 11/30/23.
//

import Foundation
import SwiftUI

var appBlue = Color(hex: "#0072bb")
var appGreen = Color(hex: "cee8db")
var appPaleGreen = Color(hex: "8eddb6")

struct GreenButton: View {
    var displayText: String
    var customAction: () -> Void
    
    var body: some View {
        Button(action: {customAction()}) {
            Text(displayText)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 35)
                    .fill(appPaleGreen).frame(width: 165.78, height: 34)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2))
        }
    }
}

struct NoActionButton: View {
    var displayText: String
    var alertMessage: String
    @State private var showAlert: Bool = false
    
    var body: some View {
        Button(action: {showAlert.toggle()}) {
            Text(displayText)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 35)
                    .fill(.gray).frame(width: 165.78, height: 34)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2))
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("NOTICE"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct BlueButton: View {
    var displayText: String
    var customAction: () -> Void
    
    var body: some View {
        Button(action: {customAction()}) {
            Text(displayText)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 35)
                    .fill(appBlue)
                    .frame(width: 224, height: 41.51)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2))
        }
    }
}

struct ExitButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "x.circle")
                    .font(.title)
                    .foregroundColor(.white)
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: -5, trailing: 0))
            Spacer()
        }
    }
}

struct EditButtonView: View {
    var displayText: String
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        Button(action: {isSheetPresented.toggle()}) {
            Text(displayText)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 35)
                    .fill(appPaleGreen).frame(width: 165.78, height: 34)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2))
        }
    }
}
