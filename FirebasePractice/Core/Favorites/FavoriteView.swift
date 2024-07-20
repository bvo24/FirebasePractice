//
//  FavoriteView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/16/24.
//

import Foundation
import SwiftUI
import Combine

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
//        .onAppear{
//            
//            
//        }
        .onFirstAppear{
            viewModel.addListenerForFavorites()
        }
    }
        
    }
}

#Preview {
    NavigationStack{
        FavoriteView()
    }
}



extension View{
    
    func onFirstAppear(perform: (() -> Void)?) -> some View{
        modifier(OnFirstViewModifer(perform: perform))
    }
    
}
