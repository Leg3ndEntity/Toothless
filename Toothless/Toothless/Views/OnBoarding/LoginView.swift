//
//  LoginView.swift
//  SwiftUI-Auth
//
//  Created by Derek Hsieh on 1/7/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    
    
    private func isValidPassword(_ password: String) -> Bool {
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special char
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack {
            colorScheme == .dark ? Color.black : Color.white
            
            VStack {
                HStack {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Image(systemName: "mail").foregroundStyle(colorScheme == .dark ? .white : .black)
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    
                    if(email.count != 0) {
                        
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                )
                
                .padding()
                
                
                HStack {
                    Image(systemName: "lock").foregroundStyle(colorScheme == .dark ? .white : .black)
                    SecureField("Password", text: $password)
                    
                    Spacer()
                    
                    if(password.count != 0) {
                        
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                )
                .padding()
                
                
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "signup"
                    }
                    
                    
                }) {
                    Text("Don't have an account?")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                
                Spacer()
                Spacer()
                
                
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            withAnimation {
                                userID = authResult.user.uid
                                isAuthenticated = true
                            }
                        }
                        
                        
                    }
                } label: {
                    Text("Sign In")
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(colorScheme == .dark ? .white : .black))
                        )
                        .padding(.horizontal)
                }
                
                
            }
            .fullScreenCover(isPresented: $isAuthenticated, content: {
                WelcomeView() // Present WelcomeView when isAuthenticated is true
                        })
            
        }
    }
}

