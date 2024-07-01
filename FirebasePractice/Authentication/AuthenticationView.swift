//
//  AuthenticationView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/25/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

//No need for this handled in authentication manager
//import FirebaseAuth



@MainActor
final class AuthenticationViewModel: ObservableObject{
    
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
    }
    
}

struct AuthenticationView: View {
    @StateObject private var viewmodel = AuthenticationViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        VStack{
            NavigationLink{
                SigninEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in with email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide , state: .normal)){
                
                Task{
                    do{
                        try await viewmodel.signInGoogle()
                        showSignInView = false
                        
                    }catch{
                         print(error)
                    }
                    
                }
                
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign in")
    }
}
 
#Preview {
    
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
