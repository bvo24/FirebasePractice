//
//  SettingsView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/26/24.
//

import SwiftUI



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
