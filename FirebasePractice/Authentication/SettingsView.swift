//
//  SettingsView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/26/24.
//

import SwiftUI

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

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Log out"){
                Task{
                    do{
                        try viewModel.logOut()
                        showSignInView = true
                    }catch{
                        print(error)
                    }
                }
                
            }
            
            Button(role: .destructive){
                
                Task{
                    do{
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    }catch{
                        print(error)
                    }
                }
                
            }label: {
                Text("Delete Account")
            }
            
            
            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true{
                anonymousSection
            }
            
            
        }
        .onAppear{
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
            
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationView{
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView{
    
    private var emailSection : some View{
        
        Section{
            Button("Reset Password"){
                Task{
                    do{
                        try await viewModel.resetPassword()
                        print("Password reset")
                    }catch{
                        print(error)
                    }
                }
                
            }
            
            Button("Update Password"){
                Task{
                    do{
                        try await viewModel.updatePassword()
                        print("Updated password")
                    }catch{
                        print(error)
                    }
                }
                
            }
            Button("Vertify email"){
                Task{
                    do{
                        try await viewModel.vertifyEmail()
                        
                        print("Vertify email")
                    }catch{
                        print(error)
                    }
                }
                
            }
            Button("Update email"){
                Task{
                    do{
                        try await viewModel.updateEmail()
                        print("Updated email")
                    }catch{
                        print(error)
                    }
                }
                
            }
        } header: {
            Text("Email functions")
        }
        
        
        
    }
    
    
    private var anonymousSection : some View{
        
        Section{
            Button("Link Google Account"){
                Task{
                    do{
                        try await viewModel.linkGoogleAccount()
                        print("Google account linked")
                    }catch{
                        print(error)
                    }
                }
                
            }
            
            Button("Link Apple"){
                Task{
                    do{
                        try await viewModel.linkAppleAccount()
                        print("Apple account linked")
                    }catch{
                        print(error)
                    }
                }
                
            }
            Button("Link email"){
                Task{
                    do{
                        try await viewModel.linkEmailAccount()
                        
                        print("Email Linked")
                    }catch{
                        print(error)
                    }
                }
                
            }
            
        } header: {
            Text("Create Account")
        }
        
        
        
    }
    
    
}
