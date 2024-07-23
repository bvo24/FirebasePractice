//
//  CrashView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/23/24.
//

import SwiftUI
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



struct CrashView: View {
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 40){
                
                Button("Click me 1") {
                                    CrashManager.shared.addLog(message: "button_1_clicked")

                                    let myString: String? = nil
                                    
                                    guard let myString else {
                                        CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                                        print("report sent")
                                        return
                                    }
                                    
                                    let string2 = myString
                                }
                Button("Click me 2"){
                    CrashManager.shared.addLog(message: "button_2_clicked")
                    fatalError("This was a fatal crash")
                }
                Button("Click me 3"){
                    CrashManager.shared.addLog(message: "button_3_clicked")
                    let array: [String] = []
                    let item = array[0]
                }
                
                
            }
            
        }
        .onAppear{
    
            CrashManager.shared.setUserId(userId: "ABC123")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLog(message: "crash_view_appeared")
        }
    }
}

#Preview {
    CrashView()
}
