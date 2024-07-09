//
//  SigninEmailViewModel.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/7/24.
//

import Foundation

@MainActor
final class SigninEmailViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Empty password or email")
            return
        }
        
        let authDataResult =  try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Empty password or email")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
    
    
}
