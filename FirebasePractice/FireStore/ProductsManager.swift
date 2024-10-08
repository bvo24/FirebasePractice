//
//  ProductsManager.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class ProductsManager{
    
    static let shared = ProductsManager()
    private init () { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference{
        productsCollection.document(productId)
    }
    
    func uploadProduct(product : Product) async throws{
        try productDocument(productId: String(product.id) ).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
        
    }
    
//    private func getAllProducts() async throws -> [Product]{
//        try await productsCollection
//
//            .getDocuments(as: Product.self)
//    }
//
//    private func getAllProductsSortedByPrice(descending : Bool) async throws -> [Product]{
//        try await productsCollection
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocuments(as: Product.self)
//    }
//
//    private func getAllProductsForCategory(category : String) async throws -> [Product]{
//        try await productsCollection
//        .whereField( Product.CodingKeys.category.rawValue , isEqualTo: category)
//        .getDocuments(as: Product.self)    }
//
//    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product]{
//        try await productsCollection
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .whereField( Product.CodingKeys.category.rawValue , isEqualTo: category)
//            .getDocuments(as: Product.self)
//    }
    private func getAllProductsQuery() -> Query{
        productsCollection
            
    }
    
    private func getAllProductsSortedByPriceQuery(descending : Bool) -> Query{
       productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getAllProductsForCategoryQuery(category : String) -> Query{
        productsCollection
        .whereField( Product.CodingKeys.category.rawValue , isEqualTo: category)
           }
    
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .whereField( Product.CodingKeys.category.rawValue , isEqualTo: category)
            
    }
    
    
    func getAllProducts(pricedescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> ([Product], DocumentSnapshot?){
        
        var query : Query = getAllProductsQuery()
        
        if let descending, let category{
            query =  getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        }else if let descending{
            query =  getAllProductsSortedByPriceQuery(descending: descending)
        }else if let category{
            query =  getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)

        
        
        
    }
    
    func getProductsByRating(count : Int, lastRating: Double? ) async throws -> [Product]{
        try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 999999])
            .getDocuments(as: Product.self )
    }
    func getProductsByRating(count : Int, lastDocument: DocumentSnapshot? ) async throws -> ([Product], DocumentSnapshot?){
        
        if let lastDocument{
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Product.self)
                
            
        }
        else{
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsWithSnapshot(as: Product.self)
        }
        
      
    }
    
    func getAllProductsCount() async throws -> Int{
        try await productsCollection.aggregateCount()
    }
    
    
    
    
}

