//
//  FirebasePracticeApp.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/24/24.
//

import SwiftUI
import Firebase
 

@main
struct FirebasePracticeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationStack{
                RootView()
            } 
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//    print("FireBase configured")
    return true
  }
    
    
    
    
    
    
}

