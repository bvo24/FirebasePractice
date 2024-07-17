//
//  ProductCellViewBuilder.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/17/24.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    let productId: String
    @State private var product : Product? = nil
    
    var body: some View {
        ZStack{
            if let product{
                ProductCellView(product: product )
            }
        }
        //Once we see this view we will load the product
        .task{
            self.product = try? await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "1")
}
