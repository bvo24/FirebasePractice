//
//  Query+EXT.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension Query{
    
//    func getDocuments<T>(as: T.Type) async throws -> [T] where T : Decodable{
//
//        let snapshot = try await self.getDocuments()
//
//        return try snapshot.documents.map({document in
//            try document.data(as: T.self)
//        })
//
//
//    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable{
        
        let (products, _) = try await getDocumentsWithSnapshot(as: type)
        return products
        
        
    }

    
    
    
    func getDocumentsWithSnapshot<T>(as: T.Type) async throws -> ([T], DocumentSnapshot?) where T : Decodable{
        
        let snapshot = try await self.getDocuments()
        
        let products =  try snapshot.documents.map({document in
            try document.data(as: T.self)
        })
    
        return (products, snapshot.documents.last )
        
        
    }
    
    
    
    
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query{
        guard let lastDocument else{
            return self
        }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int{
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    
    func addSnapShotListener<T> (as type: T.Type ) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable{
        let publisher = PassthroughSubject<[T], Error>()
        let listener = self.addSnapshotListener {
            querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("No documents")
                return
            }
            
            let products : [T] = documents.compactMap{ documentSnapshot in
                return try? documentSnapshot.data(as: T.self)
            }
            publisher.send(products)
            
            
        }
        return (publisher.eraseToAnyPublisher(), listener)
        
        
    }
    
    
    
}
