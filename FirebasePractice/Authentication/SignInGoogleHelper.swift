//
//  SignInGoogleHelper.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/29/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel{
    let idToken : String
    let accessToken : String
    let name : String?
    let email : String?
    
}

final class SignInGoogleHelper{
    
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel{
        guard let topvc = Utilities.shared.topViewController() else{
            throw URLError(.badURL)
        }
        
        
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topvc )
        
        guard let idToken : String = gidSignInResult.user.idToken?.tokenString else{
            throw URLError(.badServerResponse)
        }
        let accessToken : String = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
}
