//
//  ProductsView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/12/24.
//

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products : [Product] = []
    @Published var selectedFilter : FilterOption? = nil
    @Published var selectedCategory : CategoryOption? = nil
    
//    func getAllProducts() async throws{
//        self.products = try await ProductsManager.shared.getAllProducts()
//    }
    
    enum FilterOption : String, CaseIterable{
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool?{
            switch self{
            case .noFilter:
                return nil
            case .priceHigh:
                return true
            case .priceLow:
                return false
            }
            
        }
    }
    
    func filterSelected(option : FilterOption)async throws {
//        switch option{
//        case .noFilter:
//            self.products = try await ProductsManager.shared.getAllProducts()
//            break
//            
//        case .priceHigh:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
//            break
//        case .priceLow:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
//            break
//        }
        self.selectedFilter = option
        self.getProducts()
        
    }
    
    enum CategoryOption: String, CaseIterable{
        case noCategory
        case beauty
        case fragrances
        case groceries
        
        var categoryKey: String?{
            if  self == .noCategory{
                return nil
            }
            return self.rawValue
        }
        
    }
    
    func categorySelected(option : CategoryOption)async throws {
//        switch option{
//        case .noCategory:
//            self.products = try await ProductsManager.shared.getAllProducts()
//            break
//        case .fragrances, .beauty, .groceries:
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//            break
//        }
        self.selectedCategory = option
        self.getProducts()
        
        

        
        
    }
    
    func getProducts(){
        Task{
            self.products = try await ProductsManager.shared.getAllProducts(pricedescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey)
        }
    }
    
    
    
}



struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        
        
        
        List{
            
            ForEach(viewModel.products){ product in
                
                ProductCellView(product: product)
                
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
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack{
        ProductsView()
    }
    
}
