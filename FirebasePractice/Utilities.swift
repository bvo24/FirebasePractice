//
//  Utilities.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/28/24.
//

import Foundation
import UIKit


final class Utilities{
    
    static let shared = Utilities()
    private init(){
        
    }
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
            var controller = controller
            
            if controller == nil {
                if let windowScene = UIApplication.shared.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .compactMap({ $0 as? UIWindowScene })
                    .first {
                    
                    controller = windowScene.windows
                        .filter({ $0.isKeyWindow }).first?.rootViewController
                }
            }

            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return topViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller
        }
    
    
    
}


