//
//  ProductsDataBase.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/12/24.
//

import Foundation

struct ProductArray : Codable{
    let products : [Product]
    let total, skip, limit : Int
}

struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let description: String?
    let price: Double?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case category
        case thumbnail
        case images
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool{
        
        return lhs.id == rhs.id
    }
    
}

//Uploading json file once into data base
//    func downloadProductsAndUploadToFirebase(){
//        //https://dummyjson.com/products
//
//        guard let url = URL(string: "https://dummyjson.com/products") else {
//            return
//        }
//
//        Task{
//            do{
//                let(data, _) = try await URLSession.shared.data(from: url)
//                let products = try JSONDecoder().decode(ProductArray.self, from: data)
//                let productArray = products.products
//
//                for product in productArray {
//                    try? await ProductsManager.shared.uploadProduct(product: product)
//                }
//
//                print("success")
//                print(products.products.count)
//
//            }
//            catch{
//                print(error)
//            }
//
//        }
//
//    }
    
    
