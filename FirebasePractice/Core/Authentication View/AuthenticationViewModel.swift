//
//  AuthenticationViewModel.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/7/24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject{
    
    // Unhashed nonce.
    
    @Published var didSignInWithApple: Bool = false
    
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
//        let user = DBUser(auth: authDataResult)
//        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws{
        
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        
//        
//        let user = DBUser(auth: authDataResult)
//        try await UserManager.shared.createNewUser(user: user)
        
        
        
//        signInAppleHelper.startSignInWithAppleFlow{ result in
//
//
//            switch result{
//            case .success(let signInAppleResult):
//                Task{
//                    do{
//                        try await AuthenticationManager.shared.signInWithApple(tokens: signInAppleResult)
//                        self.didSignInWithApple = true
//                    }catch{
//
//                    }
//
//
//                }
//
//                self.didSignInWithApple = true
//
//            case .failure(let error):
//                print(error)
//            }
//
//        }
//
        
//        Task{
//            do{
//                try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
//                didSignInWithApple = true
//            }catch{
//
//            }
//
//
//        }
        
        
        
    }
    
    func signInAnonymous() async throws{
        
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
//        let user = DBUser(auth: authDataResult)
//        try await UserManager.shared.createNewUser(user: user)
        
        
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
    }
    

    

    
        
    
}
