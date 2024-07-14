//
//  ProfileView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/7/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel : ObservableObject {
    
    @Published private(set) var user : DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
    }
    
    func togglePremiumStatus(){
        guard let user else{
            return
        }
        let currentValue = user.isPremium ?? false
                
        Task{
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue )
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    
    func addUserPreference(text : String){
        guard let user else{
            return
        }
        
        Task{
            try await UserManager.shared.addUserPreference(userId: user.userId , preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
        
        
        
    }
    
    func removeUserPreference(text : String){
        guard let user else{
            return
        }
        
        Task{
            try await UserManager.shared.removeUserPreference(userId: user.userId , preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
        
        
        
    }
    
    func addFavoriteMovie(){
        guard let user else{
            return
        }
        let movie = Movie(id: "1", title: "Spongebob", isPopular: true)
        Task{
            try await UserManager.shared.addFavoriteMovie(userId: user.userId, movie: movie) 
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
        
        
    }
    func removeFavoriteMovie(){
        guard let user else{
            return
        }
        Task{
            try await UserManager.shared.removeFavoriteMovie(userId:user.userId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
        
        
    }
    
    
    
    
}


struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool  
    
    let preferenceOption = ["Sports", "Books", "Movies"]
    
    private func preferenceIsSelected (text : String) -> Bool{
        viewModel.user?.preferences?.contains(text) == true
    }
    
    
    var body: some View {
        
        List{
            if let user = viewModel.user{
                Text("User id \(user.userId)")
                
                if let isAnonymous = user.isAnonymous{
                    Text("Is anonymous \(isAnonymous)")
                }
                
                Button{
                    viewModel.togglePremiumStatus()
                }label:{
                    Text("User is premium \((user.isPremium ?? false).description.capitalized )")
                }
                
                
                VStack{
                    HStack{
                        ForEach(preferenceOption, id: \.self){ string in
                            Button(string){
                                if preferenceIsSelected(text: string){
                                    viewModel.removeUserPreference(text: string)
                                }
                                else{
                                    viewModel.addUserPreference(text: string)
                                }
                                
                                
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceIsSelected(text: string) ? .green : .red)
                            
                        }
                    }
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                }
                
                Button{
                    if user.favoriteMovie == nil{
                        viewModel.addFavoriteMovie()
                    }
                    else{
                        viewModel.removeFavoriteMovie() 
                    }
                    
                    
                    
                } label : {
                    Text("Favorite movie: \((user.favoriteMovie?.title ?? "" ))")
                }
                
                
                
            }
            
            
            
            
            
            
        }
        .task{
            
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar{
            
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink{
                    SettingsView(showSignInView: $showSignInView)
                }label:{
                    Image(systemName: "gear")
                        .font(.headline)
                }
                
            }
            
        } 
        
    }
}

#Preview {
    RootView()
}
