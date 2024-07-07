//
//  AuthenticationManager.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/25/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

struct AuthDataResultModel{
    let uid : String
    let email : String?
    let photoUrl : String?
    let isAnonymous : Bool
    
    init(user : User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
        
    }
    
}

enum AuthProviderOption : String{
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
    
    
}

final class AuthenticationManager{
    
    static let shared = AuthenticationManager()
    
    private init(){
        
    }
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption]{
        guard let providerData = Auth.auth().currentUser?.providerData else{
            throw URLError(.badServerResponse)
        }
        var providers : [AuthProviderOption] = []
        
        
        
        for provider in providerData {
            
            if let option = AuthProviderOption(rawValue: provider.providerID){
                providers.append(option)
                print(option)
                
            }else{
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers 
        
        
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func delete() async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
    
    
}


//Command option left arrow or right
//MARK: Sign in with email
extension AuthenticationManager{
    
    @discardableResult
    func createUser(email : String, password : String ) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user )
        
    }
    @discardableResult
    func signInUser(email : String, password : String ) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email : String) async throws {
       try await Auth.auth().sendPasswordReset(withEmail: email)
        
        
    }
    
    func updatePassword(password : String) async throws {
        guard let authUser = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        try await authUser.updatePassword(to: password)
    }
    
    //need send then update
    //Button needs to wait to update email
    //this function is send email
    //Maybe this isn't necessary?...
    func vertifyEmail(email : String) async throws {
        guard let authUser = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
//        let emailUser = authUser.email
        
        //try await authUser.sendEmailVerification()
       try await authUser.sendEmailVerification()
    }
    func updateEmail(email : String) async throws{
        guard let authUser = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
            
        }
        //Not sure if this is needed?..
        if authUser.isEmailVerified {
//            print("Block reached")
//            try await authUser.updateEmail(to: email)
            try await authUser.sendEmailVerification(beforeUpdatingEmail: email)
        }
        else{
            throw URLError(.badServerResponse)
        }
        
    }
    
    
    
    
    
    
}


//MARK: Sign in with SSO GOOGLE
extension AuthenticationManager{

    @discardableResult
    func signInWithGoogle(tokens : GoogleSignInResultModel) async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
         
        return try await signIn(credential: credential)
        
        
        
    }
    
    @discardableResult
    func signInWithApple(tokens : SignInWithAppleResult) async throws -> AuthDataResultModel{
        // Initialize a Firebase credential, including the user's full name.
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            
//            let credential = OAuthProvider.appleCredential(withIDToken: appleIDCredential,
//                                                           rawNonce: tokens.token,
//                                                           fullName: appleIDCredential.fullName)
//            
//            
//            return try await signIn(credential: credential)
//        }
        
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce )
        
        return try await signIn(credential: credential)
        
        
        
    }
    
    func signIn(credential : AuthCredential) async throws -> AuthDataResultModel{
        
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user )
        
        
        
    }
    
}


//MARK: SIGN IN ANONYMOUS

extension AuthenticationManager{
    
    @discardableResult
    func signInAnonymous() async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user )
        
    }
    
    func linkEmail(email : String, password : String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        return try await linkCredential(credential: credential)
        
    }
    
    func linkApple(tokens : SignInWithAppleResult) async throws -> AuthDataResultModel {
        
        
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce )
        return try await linkCredential(credential: credential)
       
        
    }
    
    func linkGoogle(tokens : GoogleSignInResultModel) async throws -> AuthDataResultModel {
        
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        
        return try await linkCredential(credential: credential)
       
        
    }
    
    private func linkCredential(credential : AuthCredential) async throws -> AuthDataResultModel {
        
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        
        let authDataResult = try await user.link(with: credential)
        return AuthDataResultModel(user: authDataResult.user )
        
    }
    
    
}

