//
//  ProfileView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/7/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool  
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    
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
                
                PhotosPicker(selection: $selectedItem, matching: .images,photoLibrary: .shared()){
                    Text("Select a photo")
                }
                //More efficient rather than constantly fetching url we upload the url in the data base
                if let urlString = viewModel.user?.profileImagePathUrl,let url = URL(string: urlString){
                    AsyncImage(url: url){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
                
                if viewModel.user?.profileImagePath != nil{
                    
                    Button("Delete Image"){
                        viewModel.deleteProfileImage()
                    }
                }
               
                
                
                
            }
            
            
            
            
            
            
        }
        .task{
            
            try? await viewModel.loadCurrentUser()
            
            
        }
        .onChange(of: selectedItem){ oldValue, newValue in
            if let newValue{
                viewModel.saveProfileImage(item: newValue)
                
            }
            
            
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
