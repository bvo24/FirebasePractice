//
//  SettingsViewModel.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/7/24.
//

import Foundation

@MainActor
final class SettingsViewModel : ObservableObject{
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser : AuthDataResultModel? = nil
    
    func loadAuthProviders(){
        if let providers = try? AuthenticationManager.shared.getProviders(){
            authProviders = providers
        }
        
    }
    
    func loadAuthUser(){
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws{
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws{
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func vertifyEmail() async throws{
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.vertifyEmail(email: email)
        
    }
    //We should receive input
    func updateEmail() async throws {
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
        
        let email = "_@gmail.com"
        //Vertify the email we want is this
        //So I can attempt to create like a menu to another menu?..
        try await AuthenticationManager.shared.vertifyEmail(email: email)
        
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    //We should receive input
    func updatePassword() async throws{
        let password = "DoggyWorld"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    func linkGoogleAccount() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
        
    }
    func linkAppleAccount() async throws{
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
        
    }
    func linkEmailAccount() async throws{
        let email = "another123v@gmail.com"
        let password = "DoggyWorld"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
        
    }
    
    
    
}
