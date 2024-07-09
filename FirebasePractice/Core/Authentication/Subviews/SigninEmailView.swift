//
//  SigninEmailView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/25/24.
//

import SwiftUI



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
