//
//  FavoriteView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/16/24.
//

import SwiftUI

@MainActor
final class favoriteViewModel : ObservableObject{
    @Published private(set) var userFavoriteProducts : [UserFavoriteProduct] = []
    
    func getFavorites(){
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await  UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
            //print(userFavoritedProducts)
            
            
           
        }
        
    }
    
    func removeFromFavorites(favoriteProductId : String){
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            getFavorites()
        }
        
    }
    
    
}

struct FavoriteView: View {
  
    @StateObject private var viewModel = favoriteViewModel()
    
    var body: some View {
        
        NavigationStack{
        List{
            ForEach(viewModel.userFavoriteProducts, id: \ .id.self){ item in
                ProductCellViewBuilder(productId:  String(item.productId))
                    .contextMenu{
                        Button("Remove from favorites"){
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                    }
            }
            
        }
        .navigationTitle("Favorites")
        .onAppear{
            viewModel.getFavorites()
        }
    }
        
    }
}

#Preview {
    NavigationStack{
        FavoriteView()
    }
}
