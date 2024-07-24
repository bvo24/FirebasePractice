//
//  CrashManager.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/24/24.
//

import Foundation
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift


final class CrashManager{
    
    static let shared = CrashManager()
    private init() {}
    
    func setUserId(userId : String){
        Crashlytics.crashlytics().setUserID(userId)
    }
    private func setValue(value: String, key: String){
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        
    }
    func setIsPremiumValue(isPremium: Bool){
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    func addLog(message: String){
        Crashlytics.crashlytics().log(message)
    }
    
//    func sendNonFatal(error: Error){
//
//        Crashlytics.crashlytics().record(error: error)
//
//    }
    
    func sendNonFatal(error: Error) {
            Crashlytics.crashlytics().record(error: error)
        }
    
    
}


