//
//  UserManager.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser : Codable{
    
    let userId : String
    let isAnonymous : Bool?
    let email : String?
    let photoUrl : String?
    let dateCreated : Date?
    
}

final class UserManager{
    
    static let shared = UserManager()
    private init () { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference{
        userCollection.document(userId)
    }
    
    
    func createNewUser (auth : AuthDataResultModel) async throws{
        
        var userData : [String : Any] = [
            "user_id" : auth.uid,
            "is_anonymous" : auth.isAnonymous,
            "date_created" : Timestamp(),
        
        ]
        
        if let email = auth.email{
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl{
            userData["photo_url"] = photoUrl
        }

        
        try await userDocument(userId: auth.uid).setData(userData, merge: false )
    }
    
    
    func getUser(userId : String) async throws -> DBUser{
        
        let snapshot = try await userDocument(userId: userId).getDocument()
         
        guard let data = snapshot.data(),
        let userId = data["user_id"] as? String
        else{
            throw URLError(.badServerResponse)
        }
        
        let isAnonymous = data["is_anonymous"] as? Bool
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
        
    }
    
}
