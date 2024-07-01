//
//  SigninEmailView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/25/24.
//

import SwiftUI

@MainActor
final class SigninEmailViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Empty password or email")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Empty password or email")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
    
    
}

struct SigninEmailView: View {
    
    @StateObject private var viewModel = SigninEmailViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10.0)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10.0)
            
            Button{
                Task{
                    do{
                        try await  viewModel.signUp()
                        showSignInView = false
                        return
                    } catch{
                            print(error)
                    }
                    
                    do{
                        try await  viewModel.signIn()
                        showSignInView = false
                        return
                    } catch{
                            print(error)
                    }
                    
                }
               
                
            }label: {
                
                Text("Sign in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                
            }
            Spacer()
            
            
        }
        .padding()
        .navigationTitle("Sign in with email")
    }
}

#Preview {
    NavigationStack{
        SigninEmailView(showSignInView: .constant(false))
    }
   
}
