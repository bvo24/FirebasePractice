//
//  ProductsViewModel.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/19/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products : [Product] = []
    @Published var selectedFilter : FilterOption? = nil
    @Published var selectedCategory : CategoryOption? = nil
    private var lastDocument : DocumentSnapshot? = nil
    
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

        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
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
        self.products = []
        self.lastDocument = nil
        self.getProducts()
        
        

        
        
    }
    
    func getProducts(){
        Task{
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(pricedescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 5, lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            
            if let lastDocument{
                self.lastDocument = lastDocument
            }
            
        }
        
                    
        
    }
    
    func addUserFavoriteProduct(productId : Int){
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId )
        }
        
        
    }
    
    
    
//    func getProductsByRating(){
//        Task{
//
////            let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating)
//
//            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument )
//
//            self.products.append(contentsOf: newProducts)
//            self.lastDocument = lastDocument
//        }
//    }
//
//    func getProductsCount(){
//        Task{
//            let count = try await ProductsManager.shared.getAllProductsCount()
//            print("All product count \(count)")
//
//        }
//    }
    
    
    
}

