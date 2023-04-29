//
//  LoginView.swift
//  WalkupManager
//
//  Created by Jonathan Wheeler Jr. on 4/26/23.
//
//
//  LoginView.swift
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            
            Image(systemName: "figure.baseball")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("Walkup Manager")
                .font(.largeTitle)
                .bold()
            
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email) // this field is bound to the .email case
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password) // this field is bound to the .password case
                    .onSubmit {
                        focusField = nil // will dismiss the keyboard
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                .tint(.red)

                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .padding(.leading)
                .tint(.red)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .padding(.top)
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            // if logged in when app runs, navigate to the new screen & skip login screen
            if Auth.auth().currentUser != nil {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ListView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { // login error occurred
                print("😡 SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration success!")
                presentSheet = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { // login error occurred
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
