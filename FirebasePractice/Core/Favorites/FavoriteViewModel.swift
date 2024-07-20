//
//  FavoriteViewModel.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/19/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class favoriteViewModel : ObservableObject{
    @Published private(set) var userFavoriteProducts : [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    func addListenerForFavorites(){
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else{
            return
        }
        
        UserManager.shared.addListenerForAllUserFavoriteProduct(userId: authDataResult.uid).sink{
            completion in
        } receiveValue: { products in
            self.userFavoriteProducts = products
        }.store(in: &cancellables)
        
//        UserManager.shared.addListenerForAllUserFavoriteProduct(userId: authDataResult.uid){ [weak self] products in
//            self?.userFavoriteProducts = products
//        }
    }
    
//    func getFavorites(){
//        Task{
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await  UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//            //print(userFavoritedProducts)
//
//
//
//        }
//
//    }
    
    func removeFromFavorites(favoriteProductId : String){
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
//            getFavorites()
        }
        
    }
    
    
}
