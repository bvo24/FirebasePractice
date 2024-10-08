//
//  UserManager.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Movie : Codable {
    let id : String
    let title : String
    let isPopular : Bool
    
}

struct DBUser : Codable{
    
    let userId : String
    let isAnonymous : Bool?
    let email : String?
    let photoUrl : String?
    let dateCreated : Date?
    let isPremium : Bool?
    let preferences : [String]?
    let favoriteMovie : Movie?
    let profileImagePath : String?
    let profileImagePathUrl : String?

    
    
    
    
    init(auth : AuthDataResultModel){
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date() 
        self.isPremium = false 
        self.preferences = nil
        self.favoriteMovie = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        
    }
    
    init(userId : String,
        isAnonymous : Bool? = nil,
        email : String? = nil,
        photoUrl : String? = nil,
        dateCreated : Date? = nil,
        isPremium : Bool? = nil,
        preferences : [String]? = nil,
        favoriteMovie : Movie? = nil,
        profileImagePath : String? = nil,
        profileImagePathUrl : String? = nil
        
         
        ){
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
//    func togglePremiumStatus() -> DBUser{
//        let currentValue = isPremium ?? false
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, isPremium: !currentValue)
//    }
//    mutating func togglePremiumStatus(){
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    
    //Custom coding keys
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photoUrl"
        case dateCreated = "dateCreated"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie )
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
    }
    
    
    
    
}

final class UserManager{
    
    static let shared = UserManager()
    private init () { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference{
        userCollection.document(userId)
    }
    
    private func userFavoriteProductCollection(userId : String) -> CollectionReference{
        userDocument(userId: userId).collection("favorite_products")
    }
    private func userFavoriteProductDocument(userId : String, favoriteProductId : String) -> DocumentReference{
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    //We have to change our data into snake case
    //Since we are using snake case in our data base
    private let encoder : Firestore.Encoder = {
        let encoder =  Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder : Firestore.Decoder = {
        let decoder =  Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user : DBUser ) async throws{
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
//    func createNewUser (auth : AuthDataResultModel) async throws{
//        
//        var userData : [String : Any] = [
//            "user_id" : auth.uid,
//            "is_anonymous" : auth.isAnonymous,
//            "date_created" : Timestamp(),
//        
//        ]
//        
//        if let email = auth.email{
//            userData["email"] = email
//        }
//        if let photoUrl = auth.photoUrl{
//            userData["photo_url"] = photoUrl
//        }
//
//        
//        try await userDocument(userId: auth.uid).setData(userData, merge: false )
//    }
    
    func getUser(userId : String) async throws -> DBUser{
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    
//    func getUser(userId : String) async throws -> DBUser{
//        
//        let snapshot = try await userDocument(userId: userId).getDocument()
//         
//        guard let data = snapshot.data(),
//        let userId = data["user_id"] as? String
//        else{
//            throw URLError(.badServerResponse)
//        }
//        
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let dateCreated = data["date_created"] as? Date
//        
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
//        
//    }
    
    
//    func updateUserPremiumStatus(user : DBUser) async throws{
//        try userDocument(userId: user.userId).setData(from: user, merge: true ,encoder: encoder)
//        
//    }
    
    func updateUserPremiumStatus(userId : String ,isPremium : Bool) async throws{
        let data : [String : Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
            
        ]
        
        
        try await userDocument(userId:  userId).updateData(data)
        
    }
    
    func updateUserProfileImagePath(userId : String ,path: String?, url : String?) async throws{
        let data : [String : Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url
            
        ]
        
        
        try await userDocument(userId:  userId).updateData(data)
        
    }
    
    func addUserPreference(userId : String, preference : String)async throws {
        
        let data : [String : Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
         
    }
    
    func removeUserPreference(userId : String, preference : String)async throws {
        
        let data : [String : Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
         
    }
    
    
    
    func addFavoriteMovie(userId : String, movie : Movie)async throws {
        
        guard let data = try? encoder.encode(movie) else{
            throw URLError(.badURL)
        }
        
        let dict : [String : Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : data
        ]
        
        try await userDocument(userId: userId).updateData(dict)
         
    }
    
    func removeFavoriteMovie(userId : String)async throws {
        
        let data : [String : Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : nil
        ]
        
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
         
    }
    
    func addUserFavoriteProduct(userId: String, productId : Int) async throws{
        //Blank document
        let document = userFavoriteProductCollection(userId: userId).document()
        //Get id of blank 
        let documentId = document.documentID
        let data : [String:Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue : documentId,
            UserFavoriteProduct.CodingKeys.productId.rawValue : productId,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId : String) async throws{
        
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
    
    func getAllUserFavoriteProducts(userId : String) async throws -> [UserFavoriteProduct]{
    
       return try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
        
    }
    
    private var userFavoriteProductListener : ListenerRegistration? = nil
    
    //Allows us to wait for a data base to change, escaping essentially is how calls can be used later and not immediately
    func addListenerForAllUserFavoriteProduct (userId : String , completion : @escaping (_ products : [UserFavoriteProduct]) -> Void ){
        self.userFavoriteProductListener = userFavoriteProductCollection(userId: userId).addSnapshotListener {
            querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("No documents")
                return
            }
            
            let products : [UserFavoriteProduct] = documents.compactMap{ documentSnapshot in
                return try? documentSnapshot.data(as: UserFavoriteProduct.self)
            }
            completion(products)
            
            
               
        }
        
        
    }
    
    
//    func addListenerForAllUserFavoriteProduct (userId : String) ->  AnyPublisher<[UserFavoriteProduct], Error> {
//        let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
//        self.userFavoriteProductListener = userFavoriteProductCollection(userId: userId).addSnapshotListener {
//            querySnapshot, error in
//            guard let documents = querySnapshot?.documents else{
//                print("No documents")
//                return
//            }
//            
//            let products : [UserFavoriteProduct] = documents.compactMap{ documentSnapshot in
//                return try? documentSnapshot.data(as: UserFavoriteProduct.self)
//            }
//            publisher.send(products)
//            
//            
//        }
//        return publisher.eraseToAnyPublisher()
//        
//        
//    }
    
    
    func addListenerForAllUserFavoriteProduct (userId : String) ->  AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId)
            .addSnapShotListener(as: UserFavoriteProduct.self)
        self.userFavoriteProductListener = listener
        return publisher
        
        
    }
    
    
    
    func removeListenerForAllUserFavoriteProduct(){
        self.userFavoriteProductListener?.remove()
    }
    
    
}
import Combine

struct UserFavoriteProduct : Codable{
    let id : String
    let productId : Int
    let dateCreated : Date
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
    enum CodingKeys:  String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
}
