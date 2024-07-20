//
//  ProductsView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/12/24.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        
        
        
        List{
            
 
            ForEach(viewModel.products){ product in
                
                ProductCellView(product: product)
                    .contextMenu{
                        Button("Add to favorites"){
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                
                if product ==  viewModel.products.last{
                    ProgressView()
                        .onAppear{
                            viewModel.getProducts()
                        }
                }
                
                
            }
            
            
        }
        .navigationTitle("Products")
        .toolbar{
            
            ToolbarItem(placement: .topBarLeading){
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")" ){
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self){ option in
                        Button(option.rawValue){
                            Task{
                                try? await viewModel.filterSelected(option: option)
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
            }
            ToolbarItem(placement: .topBarTrailing){
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")" ){
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self){ option in
                        Button(option.rawValue){
                            Task{
                                try? await viewModel.categorySelected(option:option)
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }
            
        }
        .task{
//            viewModel.getProductsCount()
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack{
        ProductsView()
    }
    
}
