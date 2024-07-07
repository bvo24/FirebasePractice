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
    
    // Unhashed nonce.
    
    @Published var didSignInWithApple: Bool = false
    
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
    }
    
    func signInApple() async throws{
        
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        
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
        
        try await AuthenticationManager.shared.signInAnonymous()
        
    }
    

    

    
        
    
}





struct AuthenticationView: View {
    @StateObject private var viewmodel = AuthenticationViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        VStack{
            
            
            
            Button(action: {
               
                Task{
                    do{
                        try await viewmodel.signInAnonymous()
                        showSignInView = false
                        
                        
                    }catch{
                         print(error)
                    }
                    
                }
                
                
            }, label: {
                Text("Sign in anonymously")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                            })
            
    
        
                
                
                
            
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
            
            Button(action: {
               
                Task{
                    do{
                        try await viewmodel.signInApple()
                        showSignInView = false
                        
                        
                    }catch{
                         print(error)
                    }
                    
                }
                
                
            }, label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    
                    .allowsHitTesting(false)
            })
            .frame(height: 55)
//            .onChange(of: viewmodel.didSignInWithApple){ oldValue, newValue in
//                if newValue{
//                    showSignInView = false
//                }
//                
//            }
            
            
            
                
            
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
